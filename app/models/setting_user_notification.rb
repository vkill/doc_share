class SettingUserNotification < ActiveRecord::Base

  belongs_to :user

  delegate :email, :username, :gravatar_url , :to => :user


end
# == Schema Information
#
# Table name: setting_user_notifications
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  user_followed      :boolean         default(TRUE)
#  repository_watched :boolean         default(TRUE)
#  repository_forked  :boolean         default(TRUE)
#  created_at         :datetime
#  updated_at         :datetime
#

