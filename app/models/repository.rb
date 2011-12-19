class Repository < ActiveRecord::Base

  #
  extend FriendlyId
  friendly_id :name

  #
  has_ancestry

  #
  acts_as_paranoid
  
  attr_accessible :user_id, :category_id, :name, :describtion, :visibility, :parent, :user, :repo_files_attributes

  belongs_to :user, :counter_cache => true
  belongs_to :category, :counter_cache => true
  has_many :repo_files
  accepts_nested_attributes_for :repo_files, :allow_destroy => true,
                                              :reject_if => Proc.new { |repo_file| repo_file['repo_file'].blank? }
  has_many :issues
  has_many :comments, :as => :commentable

  has_many :follower_followed, :as => :target, :class_name => 'TargetFollower', :readonly => true
  with_options :through => :follower_followed, :source => :follower do |follower|
    follower.has_many :watchers, :source_type => 'User'
  end

  validates :name, :presence => true,
                      :length => { :within => 6..30 }
  validates_uniqueness_of :name, :scope => :user_id
  attribute_enums :visibility, :in => [:public_repo, :private_repo], :default => :public_repo

  delegate :email, :username, :to => :user


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
      new_repository
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

end

# == Schema Information
#
# Table name: repositories
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  category_id      :integer
#  ancestry         :string(255)
#  deleted          :boolean         default(FALSE)
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
#  deleted_at       :time
#

