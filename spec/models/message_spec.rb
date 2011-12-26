require 'spec_helper'

describe Message do

  context "valid_attribute" do
    it { should have_valid(:sender).when( User.make! ) }
    it { should have_valid(:receiver).when( User.make! ) }

    it { should have_valid(:content).when('test_123' ) }
    it { should_not have_valid(:content).when('s'*5, 's'*2001, nil) }
    it { should have_valid(:category).when('system_notification', 'member_mailbox' ) }
    it { should_not have_valid(:category).when('test') }

    it { should have_valid(:subject).when('test_123' ) }
    it { should_not have_valid(:subject).when('s'*3, 's'*31, nil) }

    context "receiver_username_post" do
      it { should_not have_valid(:receiver_username_post).when('test_123' ) }
      it { should_not have_valid(:receiver_username_post).when(nil) }
      it { should have_valid(:receiver_username_post).when(User.first.username ) }
    end
    context "reply" do
      before { subject.parent = Message.make! }
      it { should have_valid(:subject).when(nil) }
    end
  end

  context "associations" do
    it { subject.association(:target).should be_instance_of(ActiveRecord::Associations::BelongsToPolymorphicAssociation) }
  end

  context "define scopes" do
    it { Message.unread.new.is_readed.should be_false }
    it "user send and receive messages query use by_user" do
      user = User.make!
      Message.make!(:sender => user)
      Message.make!(:receiver => user)
      Message.by_user(user).count.should eq(2)
    end
  end

  context "validates" do
    it "when create a new message, should validate subject" do
      pending
    end
    it "when create a new message, if receiver_username validated build receiver_id" do
      user = User.make!
      subject.receiver_id.should be_nil
      subject.receiver_username_post = user.username
      subject.valid?
      subject.receiver_id.should == user.id
      subject.receiver.should == user
    end
  end

  context "functions" do
    it "should has readed?" do
      subject.readed?.should be_false
    end
    it "should has read!" do
      subject.read!
      subject.readed?.should be_true
    end
    it "should has reply!" do
      message = Message.make!
      new_message = message.reply!("content" * 30)
      new_message.parent.id.should eq(message.id)
      new_message.receiver.id.should eq(message.sender.id)
    end
  end


end
# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  category    :string(255)
#  subject     :string(255)
#  content     :text
#  ancestry    :string(255)
#  is_readed   :boolean         default(FALSE)
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

