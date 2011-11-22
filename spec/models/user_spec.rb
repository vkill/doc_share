require 'spec_helper'

describe User do
  context "valid_attribute" do

    it { should have_valid(:roles).when( [Role.make!] ) }
    it { should have_valid(:repositories).when( [Repository.make!] ) }
    it { should have_valid(:issues).when( [Issue.make!] ) }
    it { should have_valid(:comments).when( [Comment.make!] ) }
    it { should have_valid(:sent_messages).when( [Message.make!] ) }
    it { should have_valid(:received_messages).when( [Message.make!] ) }
    it { should have_valid(:setting_user_notification).when( SettingUserNotification.make! ) }


    it { should have_valid(:username).when('test_123' ) }
    it { should_not have_valid(:username).when('s'*5, 's'*31, 'test_+', nil) }
    it { should have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
    it { should_not have_valid(:email).when('test', nil) }
    describe 'password' do
      before { subject.password_confirmation = 'password' }
      it { should have_valid(:password).when('password') }
      it { should_not have_valid(:password).when(nil) }
    end
    it { should have_valid(:name).when('test_123', nil) }
    it { should_not have_valid(:name).when('s'*1, 's'*31) }
    it { should have_valid(:gender).when('male', 'female', nil ) }
    it { should_not have_valid(:gender).when('test') }
    it { should have_valid(:site).when('http://google.com', 'google.com', nil) }
    it { should_not have_valid(:site).when('google') }
  end

  context "associations" do
    it { subject.association(:target_followed).should be_a(ActiveRecord::Associations::HasManyAssociation) }
    it { subject.association(:following_users).should be_a(ActiveRecord::Associations::HasManyThroughAssociation) }
    it { subject.association(:watching_repositories).should be_a(ActiveRecord::Associations::HasManyThroughAssociation) }

    it { subject.association(:follower_followed).should be_a(ActiveRecord::Associations::HasManyAssociation) }
    it { subject.association(:followers).should be_a(ActiveRecord::Associations::HasManyThroughAssociation) }
  end

  context "functions" do
    let(:user)  { User.make! }
    let(:admin_user)  { User.make!(:admin) }

    it "current_user should save to Thread" do
      User.current = user
      Thread.current[:user].should eq(user)
      User.current.should eq(user)
    end
    it "should has super_admin?" do
      user.super_admin?.should be_false
      admin_user.super_admin?.should be_true
    end
    it "should has has_role?" do
      user.roles << Role.make!(:code => 'admin')
      user.has_role?(:admin).should be_true
      user.has_role?(:guess).should_not be_true
    end
    it "should has has_any_role?" do
      user.roles << Role.make!(:code => 'test')
      user.has_any_role?(:test, :guess).should be_true
      user.has_any_role?(:guess).should_not be_true
    end

  end

  context "user follow user" do
    it "should follow and unfollow user" do
      user_a = User.make!
      user_b = User.make!

      user_a.follow(user_b)
      user_a.following_users.find(user_b).id.should eq(user_b.id)
      user_b.followers.find(user_a).id.should eq(user_a.id)
      user_a.unfollow(user_b)
      lambda { user_a.following_users.find(user_b) }.should raise_error(ActiveRecord::RecordNotFound)
      lambda { user_b.followers.find(user_a) }.should raise_error(ActiveRecord::RecordNotFound)
    end
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

      user_a.follow(user_b)
      user_a.following_users.count.should == 1
      user_a.following_users_count.should == 1
      user_b.followers.count.should == 1
      user_b.followers_count.should == 1
      user_c.followers.count.should == 0
      user_c.followers_count.should == 0

      user_a.follow(user_c)
      user_a.following_users.count.should == 2
      user_a.following_users_count.should == 2
      user_b.followers.count.should == 1
      user_b.followers_count.should == 1
      user_c.followers.count.should == 1
      user_c.followers_count.should == 1

      user_a.unfollow(user_b)
      user_a.following_users.count.should == 1
      user_a.following_users_count.should == 1
      user_b.followers.count.should == 0
      user_b.followers_count.should == 0
      user_c.followers.count.should == 1
      user_c.followers_count.should == 1

      user_a.unfollow(user_c)
      user_a.following_users.count.should == 0
      user_a.following_users_count.should == 0
      user_b.followers.count.should == 0
      user_b.followers_count.should == 0
      user_c.followers.count.should == 0
      user_c.followers_count.should == 0

    end
  end

  context "user watch repository" do
    it "should watch and unwatch repository" do
      user = User.make!
      repository = Repository.make!

      user.watch(repository)
      user.watching_repositories.find(repository).id.should eq(repository.id)
      repository.watchers.find(user).id.should eq(user.id)
      user.unwatch(repository)
      lambda { user.watching_repositories.find(repository) }.should raise_error(ActiveRecord::RecordNotFound)
      lambda { repository.watchers.find(user) }.should raise_error(ActiveRecord::RecordNotFound)
    end
    it "should count the number of watched repository" do
      user = User.make!
      repository = Repository.make!

      user.watching_repositories.count.should == 0
      user.watching_repositories_count.should == 0
      repository.watchers.count.should == 0
      repository.watchers_count.should == 0

      user.watch(repository)
      user.watching_repositories.count.should == 1
      user.watching_repositories_count.should == 1
      repository.watchers.count.should == 1
      repository.watchers_count.should == 1

      user.unwatch(repository)
      user.watching_repositories.count.should == 0
      user.watching_repositories_count.should == 0
      repository.watchers.count.should == 0
      repository.watchers_count.should == 0
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                              :integer         not null, primary key
#  username                        :string(255)     not null
#  email                           :string(255)
#  crypted_password                :string(255)
#  salt                            :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string(255)
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  last_login_at                   :datetime
#  last_logout_at                  :datetime
#  last_activity_at                :datetime
#  failed_logins_count             :integer         default(0)
#  lock_expires_at                 :datetime
#  is_super_admin                  :boolean         default(FALSE)
#  name                            :string(255)
#  gender                          :string(255)
#  site                            :string(255)
#  company                         :string(255)
#  location                        :string(255)
#  state                           :string(255)
#  repositories_count              :integer         default(0)
#  issues_count                    :integer         default(0)
#  comments_count                  :integer         default(0)
#  sent_messages_count             :integer         default(0)
#  received_messages_count         :integer         default(0)
#  followers_count                 :integer         default(0)
#  watching_repositories_count     :integer         default(0)
#  following_users_count           :integer         default(0)
#

