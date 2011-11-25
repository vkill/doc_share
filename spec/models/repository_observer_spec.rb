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

end

