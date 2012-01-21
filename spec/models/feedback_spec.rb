require 'spec_helper'

describe Feedback do
  
  let(:handler) { User.make! }
  subject { Feedback.make!() }
  let(:feedback_handler_processing) { Feedback.make!(:user_id => handler.id, :state => :processing, :result => 'x' * 10) }
  let(:feedback_handler_processed) { Feedback.make!(:user_id => handler.id, :state => :processed, :result => 'x' * 10) }

  context "shoulda" do
    it { should belong_to(:handler) }

    it { should allow_mass_assignment_of(:username) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:body) }
    it { should allow_mass_assignment_of(:attachment) }
    it { should allow_mass_assignment_of(:username).as(:admin) }
    it { should allow_mass_assignment_of(:email).as(:admin) }
    it { should allow_mass_assignment_of(:body).as(:admin) }
    it { should allow_mass_assignment_of(:attachment).as(:admin) }
    it { should allow_mass_assignment_of(:state).as(:admin) }
    it { should allow_mass_assignment_of(:result).as(:admin) }
    it { should allow_mass_assignment_of(:user_id).as(:admin) }

    #valid attachment
    it { should validate_presence_of(:username) }
    #valid username exclusion
    it { should validate_presence_of(:email) }
    it { should validate_format_of(:email).with('vkill.net@gmail.com') }
    it { should validate_format_of(:email).not_with('123') }
    it { should validate_presence_of(:body) }
    it { should ensure_length_of(:body).is_at_least(6).is_at_most(300) }

    it { should_not validate_presence_of(:result) }

    context "have handler and processing" do
      subject { feedback_handler_processing }
      it { should_not validate_presence_of(:result) }
    end
    context "have handler and processed" do
      subject { feedback_handler_processed }
      it { should validate_presence_of(:result) }
    end
  end

  context "delegate" do
    it { lambda { subject.handler_email }.should raise_error }
    it { lambda { subject.handler_username }.should raise_error }
    context "have handler" do
      subject { feedback_handler_processed }
      its(:handler_email) { should eq(handler.email) }
      its(:handler_username) { should eq(handler.username) }
    end
  end

  context "callbacks" do
    it "when processed? should build handle_at on before_save" do
      Timecop.freeze(Time.zone.now) do
        subject.handle_at.should be_nil
        subject.state = :processed
        subject.result = 'x' * 10
        subject.save!
        subject.handle_at.should eq(Time.zone.now)
      end
    end
  end
end
# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  email      :string(255)
#  body       :text
#  state      :string(255)
#  result     :text
#  handler_id :integer
#  handle_at  :datetime
#  attachment :string(255)
#  created_at :datetime
#  updated_at :datetime
#

