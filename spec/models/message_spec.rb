require 'spec_helper'

describe Message do

  context "valid_attribute" do
    it { should have_valid(:sender).when( User.make! ) }
    it { should have_valid(:receiver).when( User.make! ) }

    it { should have_valid(:content).when('test_123' ) }
    it { should_not have_valid(:content).when('s'*5, 's'*2001, nil) }
    it { should have_valid(:category).when('system_notification', 'member_mailbox' ) }
    it { should_not have_valid(:category).when('test') }
  end

  context "associations" do
    it { subject.association(:target).should be_a(ActiveRecord::Associations::BelongsToPolymorphicAssociation) }
  end

  context "define scopes" do
    it { Activity.unread.new.is_readed.should be_false }
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
      new_message = message.reply!(content)
      new_message.parent.id.should eq(message.id)
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
#  is_readed   :boolean         default(FALSE)
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

