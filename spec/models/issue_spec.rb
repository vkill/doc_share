require 'spec_helper'

describe Issue do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }
    it { should have_valid(:repository).when( Repository.make! ) }
    it { should have_valid(:comments).when( [Comment.make!] ) }

    it { should have_valid(:title).when('test_123' * 2 ) }
    it { should_not have_valid(:title).when('s'*5, 's'*31, nil) }
    it { should have_valid(:content).when('test_123' ) }
    it { should_not have_valid(:content).when('s'*5, 's'*2001, nil) }
    it { should have_valid(:state).when('open', 'closed' ) }
    it { should_not have_valid(:state).when('test') }
  end

end
# == Schema Information
#
# Table name: issues
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  repository_id    :integer
#  title            :string(255)
#  content          :text
#  state            :string(255)
#  number_with_repo :integer
#  created_at       :datetime
#  updated_at       :datetime
#  comments_count   :integer         default(0)
#

