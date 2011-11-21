require 'spec_helper'

describe Comment do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }

    it { should have_valid(:content).when('test_123' ) }
    it { should_not have_valid(:content).when('s'*5, 's'*2001, nil) }
  end

  context "associations" do
    it { subject.association(:commentable).should be_a(ActiveRecord::Associations::BelongsToPolymorphicAssociation) }
  end

end
# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  content          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

