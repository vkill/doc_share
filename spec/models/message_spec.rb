require 'spec_helper'

describe Message do

  context "valid_attribute" do
    it { should have_valid(:sender).when( User.make! ) }
    it { should have_valid(:receiver).when( User.make! ) }

    it { should have_valid(:content).when('test_123' ) }
    it { should_not have_valid(:content).when('s'*5, 's'*2001, nil) }
    it { should have_valid(:category).when('system_notification', 'member_mailbox' ) }
    it { should_not have_valid(:category).when('test', nil) }
  end

end
# == Schema Information
#
# Table name: messages
#
#  id          :integer         not null, primary key
#  sender_id   :integer
#  recerver_id :integer
#  category    :string(255)
#  content     :text
#  is_readed   :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

