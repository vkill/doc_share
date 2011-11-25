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

  context "count when user 'follow' target" do
    it "should count the number of followed user" do
      user_a = User.make!
      user_b = User.make!
      user_c = User.make!

      user_a.following_users.count.should == 0
      user_a.following_users_count.should == 0
      user_b.followers.count.should == 0
      user_b.followers_count.should == 0
      user_c.followers.count.should == 0
      user_c.followers_count.should == 0

      user_a.follow_user(user_b)
      user_a.reload
      user_b.reload
      user_a.following_users.count.should == 1
      user_a.following_users_count.should == 1
      user_b.followers.count.should == 1
      user_b.followers_count.should == 1
      user_c.followers.count.should == 0
      user_c.followers_count.should == 0

      user_a.follow_user(user_c)
      user_a.reload
      user_c.reload
      user_a.following_users.count.should == 2
      user_a.following_users_count.should == 2
      user_b.followers.count.should == 1
      user_b.followers_count.should == 1
      user_c.followers.count.should == 1
      user_c.followers_count.should == 1

      user_a.unfollow_user(user_b)
      user_a.reload
      user_b.reload
      user_a.following_users.count.should == 1
      user_a.following_users_count.should == 1
      user_b.followers.count.should == 0
      user_b.followers_count.should == 0
      user_c.followers.count.should == 1
      user_c.followers_count.should == 1

      user_a.unfollow_user(user_c)
      user_a.reload
      user_c.reload
      user_a.following_users.count.should == 0
      user_a.following_users_count.should == 0
      user_b.followers.count.should == 0
      user_b.followers_count.should == 0
      user_c.followers.count.should == 0
      user_c.followers_count.should == 0

    end

    it "should count the number of watched repository" do
      user = User.make!
      repository = Repository.make!

      user.watching_repositories.count.should == 0
      user.watching_repositories_count.should == 0
      repository.watchers.count.should == 0
      repository.watchers_count.should == 0

      user.watch_repository(repository)
      user.reload
      repository.reload
      user.watching_repositories.count.should == 1
      user.watching_repositories_count.should == 1
      repository.watchers.count.should == 1
      repository.watchers_count.should == 1

      user.unwatch_repository(repository)
      user.reload
      repository.reload
      user.watching_repositories.count.should == 0
      user.watching_repositories_count.should == 0
      repository.watchers.count.should == 0
      repository.watchers_count.should == 0
    end
  end

end

