class Repository < ActiveRecord::Base

  include Paramable

  extend FriendlyId
  friendly_id :name

  has_ancestry

  attr_accessible :user_id, :category_id, :name, :describtion, :visibility, :parent, :user

  belongs_to :user, :counter_cache => true
  belongs_to :category, :counter_cache => true
  has_many :repo_files
  has_many :issues
  has_many :comments, :as => :commentable

  has_many :follower_followed, :as => :target, :class_name => 'TargetFollower', :readonly => true
  with_options :through => :follower_followed, :source => :follower do |follower|
    follower.has_many :watchers, :source_type => 'User'
  end

  validates :name, :presence => true,
                      :length => { :within => 6..30 }
  attribute_enums :visibility, :in => [:public, :private], :default => :public

  delegate :email, :username, :to => :user

  default_scope order('created_at DESC')

  def fork_by!(user)
    new_repository = user.repositories.create(
      :category_id => category_id,
      :name => name,
      :describtion => describtion,
      :parent => self
    )
    new_repository
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
#  created_at       :datetime
#  updated_at       :datetime
#  watchers_count   :integer         default(0)
#  repo_files_count :integer         default(0)
#  issues_count     :integer         default(0)
#  comments_count   :integer         default(0)
#  forks_count      :integer         default(0)
#

