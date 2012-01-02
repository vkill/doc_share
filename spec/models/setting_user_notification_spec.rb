require 'spec_helper'

describe SettingUserNotification do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }
  end

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

