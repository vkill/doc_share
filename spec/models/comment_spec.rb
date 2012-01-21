require 'spec_helper'

describe Comment do

  let(:user) { User.make! }
  subject { Comment.make!(:user => user) }

  context "shoulda" do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }

    it { should allow_mass_assignment_of(:user_id) }
    it { should allow_mass_assignment_of(:user) }
    it { should allow_mass_assignment_of(:content) }
    it { should allow_mass_assignment_of(:commentable) }
    it { should allow_mass_assignment_of(:commentable_id) }
    it { should allow_mass_assignment_of(:commentable_type) }
    it { should allow_mass_assignment_of(:user_id).as(:admin) }
    it { should allow_mass_assignment_of(:user).as(:admin) }
    it { should allow_mass_assignment_of(:content).as(:admin) }
    it { should allow_mass_assignment_of(:commentable).as(:admin) }
    it { should allow_mass_assignment_of(:commentable_id).as(:admin) }
    it { should allow_mass_assignment_of(:commentable_type).as(:admin) }

    it { should validate_presence_of(:content) }
    it { should ensure_length_of(:content).is_at_least(6).is_at_most(2000) }
  end

  context "delegate" do
    its(:email) {should eq(user.email)}
    its(:username) {should eq(user.username)}
    its(:gravatar_url) {should eq(user.gravatar_url)}
  end

  context "methods" do
    it "has html_anchor" do
      subject.html_anchor.should == "comment-#{subject.id}"
    end
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
#  content          :text
#  created_at       :datetime
#  updated_at       :datetime
#

