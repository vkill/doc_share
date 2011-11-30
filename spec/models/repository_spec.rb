require 'spec_helper'

describe Repository do

  context "valid_attribute" do
    it { should have_valid(:user).when( User.make! ) }
    it { should have_valid(:category).when( Category.make! ) }
    it { should have_valid(:repo_files).when( [RepoFile.make!] ) }
    it { should have_valid(:issues).when( [Issue.make!] ) }
    it { should have_valid(:comments).when( [Comment.make!] ) }


    it { should have_valid(:name).when('test_123' * 2 ) }
    it { should_not have_valid(:name).when('s'*5, 's'*31, nil) }
    it { should have_valid(:visibility).when('public', 'private' ) }
    it { should_not have_valid(:visibility).when('test') }
  end

  context "associations" do
    it { subject.association(:follower_followed).should be_a(ActiveRecord::Associations::HasManyAssociation) }
    it { subject.association(:watchers).should be_a(ActiveRecord::Associations::HasManyThroughAssociation) }
  end

  context "fork by user" do
    before {
      user = User.make!
      repository_a = Repository.make!
    }
    it "should fork by user, and forked repository.root eq root repository" do
      new_repository = repository_a.fork_by!(user)

      new_repository.parent.id.should eq(repository_a.id)
    end

    it "repository.root forks_count should +1" do
      repository_b = repository_a.fork_by!(user)
      repository_a.reload.forks_count.should == 1
      repository_c = repository_b.fork_by!(user)
      repository_a.reload.forks_count.should == 2
    end

    it "has forks method" do
      new_repository = repository_a.fork_by!(user)
      repository_a.forks.should eq([repository_a])
      repository_a.forks.size.should == 1
    end
  end

end
# == Schema Information
#
# Table name: repositories
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  category_id      :integer
#  ancestry         :string(255)
#  deleted          :boolean         default(FALSE)
#  name             :string(255)
#  describtion      :text
#  visibility       :string(255)
#  features         :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  watchers_count   :integer         default(0)
#  repo_files_count :integer         default(0)
#  issues_count     :integer         default(0)
#  comments_count   :integer         default(0)
#  forks_count      :integer         default(0)
#

