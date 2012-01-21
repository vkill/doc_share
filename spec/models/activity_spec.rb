require 'spec_helper'

describe Activity do

  let(:user) { User.make! }
  let(:repository) { Repository.make! }
  subject { Activity.make!(:user => user, :action => :created_repository,:activityable => repository) }

  context "shoulda" do
    it { should belong_to(:user) }
    it { should belong_to(:activityable) }
  end

  context "delegate" do
    its(:email) {should eq(user.email)}
    its(:username) {should eq(user.username)}
    its(:gravatar_url) {should eq(user.gravatar_url)}
  end

  context "scopes" do
    it "should has actions scope" do
      Activity::ACTIONS.each do |action|
        Activity.send(action).new.action.to_s.should eq(action.to_s)
      end
    end

    # (user_id in current_user.following_user_ids) and 
    # (activityable==watching_repositories and user_id != current_user.id)
    it "should has about_user" do
      following_user = User.make!
      user.follow_user(following_user)
      Activity.make!(:user => following_user)

      watching_repository = Repository.make!
      user.watch_repository(watching_repository)
      Activity.make!(:activityable => watching_repository)

      Activity.make!(:activityable => watching_repository, :user => user)
 
      Activity.about_user(user).count.should eq(3) #2 + watching_repository created
    end
  end

  context "methods" do
    it "should has self.log!" do
      lambda { @activity_log = Activity.log!(:user => user, :action => :created_repository,
                    :activity_target => repository) }.should_not raise_error
      @activity_log.should be_kind_of(Activity)
    end

    it "should has target_link_body" do
      subject.target_link_body.should == "#{subject.activityable_type}##{subject.activityable_id}"
    end
  end

end
# == Schema Information
#
# Table name: activities
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  user_name         :string(255)
#  action            :string(255)
#  activityable_id   :integer
#  activityable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

