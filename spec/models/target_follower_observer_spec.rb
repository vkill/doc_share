require 'spec_helper'

describe TargetFollowerObserver do

  context "log activities" do
    it "should log activities when user follow or unfollow user" do
      user_a = User.make!
      user_b = User.make!

      user_a.follow_user(user_b)
      Activity.followed_user.where(:target_id => user_b, :target_type => 'User').blank?.should be_false

      user_a.unfollow_user(user_b)
      Activity.unfollowed_user.where(:target_id => user_b, :target_type => 'User').blank?.should be_false
    end

    it "should log activities when user watch or unwatch repository" do
      user = User.make!
      repository = Repository.make!

      user.watch_repository(repository)
      Activity.watched_repository.where(:target_id => repository, :target_type => 'Repository').blank?.should be_false

      user.unwatch_repository(repository)
      Activity.unwatched_repository.where(:target_id => repository, :target_type => 'Repository').blank?.should be_false
    end
  end

end

