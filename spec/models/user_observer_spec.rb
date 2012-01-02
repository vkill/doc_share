require 'spec_helper'

describe UserObserver do
  
  context "when user create, setting user notification" do
    let(:user) { User.make! }
    it "should have setting_user_notification" do
      user.setting_user_notification.should be_kind_of(SettingUserNotification)
    end
    it "should have notification_user_followed" do
      user.should respond_to(:notification_user_followed)
    end
  end

end
