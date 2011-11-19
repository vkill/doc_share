require 'spec_helper'

describe SettingUserNotification do
  pending "add some examples to (or delete) #{__FILE__}"
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

