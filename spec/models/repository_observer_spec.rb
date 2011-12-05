require 'spec_helper'

describe RepositoryObserver do

  context "log activities" do
    it "should log activities when user create or destroy repository" do
      repository = Repository.make!

      Activity.created_repository.where(:target_id => repository, :target_type => 'Repository').blank?.should be_false
      repository.destroy
      Activity.destroyed_repository.where(:target_id => repository, :target_type => 'Repository').blank?.should be_false
    end

    it "should log activities when user fork repository" do
      user = User.make!
      repository = Repository.make!

      new_repository = repository.fork_by!(user)
      Activity.forked_repository.where(:target_id => new_repository, :target_type => 'Repository').blank?.should be_false
    end
  end

  context "+- *_repositories_count" do
    it "when repository created or destroyed, judge visibility +-1 (visibility)_repositories_count" do
      user = User.make!
      repository = Repository.make!(:user => user, :visibility => :public)
      user.reload.public_repositories_count.should == 1
      repository.destroy
      user.reload.public_repositories_count.should == 0

      repository = Repository.make!(:user => user, :visibility => :private)
      user.reload.private_repositories_count.should == 1
      repository.destroy
      user.reload.private_repositories_count.should == 0
    end

    it "when repository before update, if visibility changed, -1 (changed_visibility)_repositories_count" do
      user = User.make!
      repository = Repository.make!(:user => user, :visibility => :public)
      user.reload
      user.public_repositories_count.should == 1
      user.private_repositories_count.should == 0
      repository.visibility = :private
      repository.save
      user.reload
      user.public_repositories_count.should == 0
      user.private_repositories_count.should == 1
    end

    context "create bare git repository when created" do
      it "" do
      end
    end
  end

end

