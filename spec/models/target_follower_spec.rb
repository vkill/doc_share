require 'spec_helper'

describe TargetFollower do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }
  end

  context "associations" do
    it { subject.association(:follower).should be_a(ActiveRecord::Associations::BelongsToPolymorphicAssociation) }
    it { subject.association(:target).should be_a(ActiveRecord::Associations::BelongsToPolymorphicAssociation) }
  end
end
# == Schema Information
#
# Table name: target_followers
#
#  id            :integer         not null, primary key
#  follower_id   :integer
#  follower_type :string(255)
#  target_id     :integer
#  target_type   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

