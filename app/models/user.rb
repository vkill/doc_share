class User < ActiveRecord::Base

  authenticates_with_sorcery!

  has_and_belongs_to_many :roles, :join_table => :roles_users, :uniq => true
  has_many :comments
  has_many :issues
  has_many :sent_messages, :foreign_key => :sender_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :receiver_id, :class_name => "Message"

  has_many :repositories

  has_one :setting_user_notification

  has_many :target_followed, :as => :follower, :class_name => 'TargetFollower'
  with_options :through => :target_followed, :source => :target, :readonly => true do |target|
    target.has_many :following_users, :source_type => 'User'
    target.has_many :watching_repositories, :source_type => 'Repository'
  end

  has_many :follower_followed, :as => :target, :class_name => 'TargetFollower', :readonly => true
  with_options :through => :follower_followed, :source => :follower do |follower|
    follower.has_many :followers, :source_type => 'User'
  end


  validates :username, :presence => true,
                        :length => { :within => 6..30 },
                        :uniqueness => true,
                        :format => { :with => /^[A-Za-z0-9_]+$/ }
  validates :email, :presence => true,
                    :email => true
  validates :password, :confirmation => true,
                      :length => { :within => 6..30 }
  symbolize :gender, :in => [:male, :female],
                    :scopes => true, :i18n => true,
                    :methods => true, :allow_blank => true
  validates :name, :length => { :within => 2..30 },
                    :if => Proc.new { |record| record.name? }
  validates_url :site, :if => Proc.new { |record| record.site? }


  class << self
    def current=(user)
      Thread.current[:user] = user
    end

    def current
      Thread.current[:user]
    end
  end

  def super_admin?
    !!is_super_admin
  end

  def has_role?(role)
    return true if role.to_s == "admin"
    !self.roles.where(:code => role.to_s).blank?
  end

  def has_any_role?(*roles)
    return true if roles.map{|x| x.to_s == 'admin'}.index(true)
    !self.roles.where(:code => roles).blank?
  end

  def following_user?(user)
    !self.following_users.where(:id => user.id).blank?
  end

  def watching_repository?(repository)
    !self.watching_repositories.where(:id => repository.id).blank?
  end

  def follow_user(user)
    follow_target(user)
    increment_following_users_count
    user.send :increment_followers_count
    self.reload && user.reload
  end

  def unfollow_user(user)
    unfollow_target(user)
    decrement_following_users_count
    user.send :decrement_followers_count
    self.reload && user.reload
  end

  def watch_repository(repository)
    follow_target(repository)
    increment_watching_repositories_count
    repository.send :increment_watchers_count
    self.reload && repository.reload
  end

  def unwatch_repository(repository)
    unfollow_target(repository)
    decrement_watching_repositories_count
    repository.send :decrement_watchers_count
    self.reload && repository.reload
  end

  private
    def follow_target(target)
      self.target_followed.create(
        :target_id => target.id,
        :target_type => target.class.model_name
      ) && self.reload && target.reload unless target == self || target.nil?
    end

    def unfollow_target(target)
      self.target_followed.where(
        :target_id => target.id,
        :target_type => target.class.model_name
      ).first.try(:destroy) && self.reload && target.reload unless target == self || target.nil?
    end

    ##########
    def increment_following_users_count
      ::User.increment_counter(:following_users_count, self.id)
    end

    def decrement_following_users_count
      ::User.decrement_counter(:following_users_count, self.id)
    end

    def increment_followers_count
      ::User.increment_counter(:followers_count, self.id)
    end

    def decrement_followers_count
      ::User.decrement_counter(:followers_count, self.id)
    end

    ##########
    def increment_watching_repositories_count
      ::User.increment_counter(:watching_repositories_count, self.id)
    end

    def decrement_watching_repositories_count
      ::User.decrement_counter(:watching_repositories_count, self.id)
    end


end
# == Schema Information
#
# Table name: users
#
#  id                              :integer         not null, primary key
#  username                        :string(255)     not null
#  email                           :string(255)
#  crypted_password                :string(255)
#  salt                            :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  last_login_at                   :datetime
#  last_logout_at                  :datetime
#  last_activity_at                :datetime
#  failed_logins_count             :integer         default(0)
#  lock_expires_at                 :datetime
#  is_super_admin                  :boolean         default(FALSE)
#  name                            :string(255)
#  gender                          :string(255)
#  site                            :string(255)
#  company                         :string(255)
#  location                        :string(255)
#  state                           :string(255)
#  repositories_count              :integer         default(0)
#  issues_count                    :integer         default(0)
#  comments_count                  :integer         default(0)
#  sent_messages_count             :integer         default(0)
#  received_messages_count         :integer         default(0)
#  followers_count                 :integer         default(0)
#  watching_repositories_count     :integer         default(0)
#  following_users_count           :integer         default(0)
#

