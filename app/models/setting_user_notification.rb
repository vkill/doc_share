class SettingUserNotification < ActiveRecord::Base

  belongs_to :user

  delegate :email, :username, :to => :user

end
# == Schema Information
#
# Table name: setting_user_notifications
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  user_followed :boolean         default(TRUE)
#  code_watched  :boolean         default(TRUE)
#  code_forked   :boolean         default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#

