class User < ActiveRecord::Base

  authenticates_with_sorcery!

  has_and_belongs_to_many :roles, :join_table => :roles_users, :uniq => true
  has_many :sent_messages, :foreign_key => :sender_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :receiver_id, :class_name => "Message"
  has_many :repositories
  has_many :issues
  has_many :comments, :as => :commentable



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
#  messages_count                  :integer         default(0)
#  followers_count                 :integer         default(0)
#  watching_repositories_count     :integer         default(0)
#  following_users_count           :integer         default(0)
#

