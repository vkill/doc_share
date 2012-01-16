class Repository < ActiveRecord::Base

  #
  extend FriendlyId
  friendly_id :name

  #
  has_ancestry

  #
  acts_as_paranoid

  #acts-as-taggable-on
  acts_as_taggable
  validates :tag_list, :tag_list_size => { :maximum => 3 },
                      :unless => lambda{ tag_list.blank? }

  basic_attr_accessible = [:user_id, :category_id, :category, :name, :describtion, :visibility,
                          :parent, :user, :repo_files_attributes, :tag_list]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin


  belongs_to :user, :counter_cache => true
  belongs_to :category, :counter_cache => true
  has_many :repo_files, :dependent => :destroy
  accepts_nested_attributes_for :repo_files, :allow_destroy => true,
                                              :reject_if => Proc.new { |repo_file| repo_file['repo_file'].blank? }
  has_many :issues, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  has_many :follower_followed, :as => :target, :class_name => 'TargetFollower', :readonly => true
  with_options :through => :follower_followed, :source => :follower do |follower|
    follower.has_many :watchers, :source_type => 'User'
  end
  has_many :activities, :as => :activityable, :dependent => :destroy
  

  scope :with_category, lambda{ |category|
    ransack({:category_id_in=>category.child_ids}).result()
  }

  def category_ancestor_id
    category.parent.try(:id) if category.present?
  end
  def get_category_values
    if category.present?
      if category.parent.present?
        category.parent.children.map{|x| [x.name, x.id]}
      else
        []
      end
    else
      []
    end
  end

  validates :category_id, :presence => true
  validates :name, :presence => true,
                      :length => { :within => 6..30 }
  validates :describtion, :length => { :maximum => 1000 },
                          :if => lambda{ describtion? }
  validates_uniqueness_of :name, :scope => :user_id
  attribute_enums :visibility, :in => [:public_repo, :private_repo], :default => :public_repo

  delegate :email, :username, :gravatar_url , :to => :user
  delegate :name, :to => :category, :prefix => true

  # Thinking Sphinx Indexing
  define_index do
    indexes name, :sortable => true
    indexes describtion
    has user_id, created_at, updated_at
  end

  # before_validation :build_category_id, :unless => lambda { category_id? }

  def fork_by!(user)
    if forked_by_user?(user)
      self.forked_by_user(user)
    else
      new_repository = user.repositories.create!(
        :category_id => category_id,
        :name => name,
        :describtion => describtion,
        :parent => self,
        :user => user
      )
      UserNotificationsMailer.repository_forked_email(self.user, self, user).deliver! if self.user.notification_repository_watched.present?
      return new_repository
    end
  end

  def forks
    self.descendants
  end

  def forked_by_user(user)
    forks.where(:user_id => user.id).first
  end

  def forked_by_user?(user)
    forks.where(:user_id => user.id).exists?
  end

  def git_repo
    Grit::Repo.new(git_repo_path)
  end

  def visibility_prefix
    self.visibility.to_s.split("_")[0]
  end

  private
    
    def build_category_id
      self.category_id = Category.first.id
    end

end

# == Schema Information
#
# Table name: repositories
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  category_id      :integer
#  ancestry         :string(255)
#  name             :string(255)
#  describtion      :text
#  visibility       :string(255)
#  features         :string(255)
#  git_repo_path    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  watchers_count   :integer         default(0)
#  repo_files_count :integer         default(0)
#  issues_count     :integer         default(0)
#  comments_count   :integer         default(0)
#  forks_count      :integer         default(0)
#  deleted_at       :datetime
#

