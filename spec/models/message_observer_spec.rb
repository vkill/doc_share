require 'spec_helper'

describe MessageObserver do

  context "+- unread_*_count" do
    let(:user) { User.make! }
    it "when system_notification message is created, count should !zero" do
      message = Message.make!(:receiver => user)
      message.categroy = :system_notification
      message.save
      user.unread_system_notifications_count.should eq(1)
      message.read!
      user.unread_system_notifications_count.should eq(0)
    end

    it "when member_mailbox message is created, count should !zero" do
      message = Message.make!(:receiver => user)
      message.categroy = :member_mailbox
      message.save
      user.unread_system_notifications_count.should eq(1)
      message.read!
      user.unread_system_notifications_count.should eq(0)
    end
  end

end

