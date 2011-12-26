class User < ActiveRecord::Base

  #
  extend FriendlyId
  friendly_id :username

  #
  include Gravtastic
  gravtastic

  #
  acts_as_paranoid

  #
  authenticates_with_sorcery!

  attr_accessor :login ,:remember_me

  basic_attr_accessible = [:email, :password, :password_confirmation, :login, :remember_me,
                  :name, :site, :company, :location]
  attr_accessible *(basic_attr_accessible + [:username ])
  attr_accessible *(basic_attr_accessible + [:username, :state, :roles, :role_ids]), :as => :admin

  has_many :roles_users, :class_name => "RolesUsers"
  has_many :roles, :through => :roles_users, :uniq => true, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :sent_messages, :foreign_key => :sender_id, :class_name => "Message", :dependent => :destroy
  has_many :received_messages, :foreign_key => :receiver_id, :class_name => "Message"

  has_many :repositories, :dependent => :destroy

  has_many :activities

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

  attribute_enums :state, :in => [:actived, :paused], :default => :actived

  validates :username, :presence => true,
                        :length => { :within => 4..30 },
                        :uniqueness => true,
                        :format => { :with => /^[A-Za-z0-9_]+$/ }
  validates :email, :presence => true,
                    :email => true
  validates :password, :confirmation => true,
                      :length => { :within => 6..30 },
                      :on => :create
  attribute_enums :gender, :in => [:male, :female], :allow_blank => true
  validates :name, :length => { :within => 2..30 },
                    :if => Proc.new { |record| record.name? }
  validates :site, :url => true,
                  :if => Proc.new { |record| record.site? }

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
  end

  def unfollow_user(user)
    unfollow_target(user)
  end

  def watch_repository(repository)
    follow_target(repository)
  end

  def unwatch_repository(repository)
    unfollow_target(repository)
  end

  def unread_any_messages_count
    unread_system_notifications_count + unread_member_mailboxs_count
  end

  scope :activity, lambda { |n| order("last_activity_at").limit(n) }
  scope :recent_join, lambda { |n| order("created_at").limit(n) }

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

end
# == Schema Information
#
# Table name: users
#
#  id                                :integer         not null, primary key
#  username                          :string(255)     not null
#  email                             :string(255)
#  crypted_password                  :string(255)
#  salt                              :string(255)
#  created_at                        :datetime
#  updated_at                        :datetime
#  remember_me_token                 :string(255)
#  remember_me_token_expires_at      :datetime
#  reset_password_token              :string(255)
#  reset_password_token_expires_at   :datetime
#  reset_password_email_sent_at      :datetime
#  last_login_at                     :datetime
#  last_logout_at                    :datetime
#  last_activity_at                  :datetime
#  failed_logins_count               :integer         default(0)
#  lock_expires_at                   :datetime
#  activation_state                  :string(255)
#  activation_token                  :string(255)
#  activation_token_expires_at       :datetime
#  is_super_admin                    :boolean         default(FALSE)
#  name                              :string(255)
#  gender                            :string(255)
#  site                              :string(255)
#  company                           :string(255)
#  location                          :string(255)
#  state                             :string(255)
#  repositories_count                :integer         default(0)
#  public_repositories_count         :integer         default(0)
#  private_repositories_count        :integer         default(0)
#  issues_count                      :integer         default(0)
#  comments_count                    :integer         default(0)
#  sent_messages_count               :integer         default(0)
#  received_messages_count           :integer         default(0)
#  followers_count                   :integer         default(0)
#  watching_repositories_count       :integer         default(0)
#  following_users_count             :integer         default(0)
#  unread_system_notifications_count :integer         default(0)
#  unread_member_mailboxs_count      :integer         default(0)
#  deleted_at                        :time
#

