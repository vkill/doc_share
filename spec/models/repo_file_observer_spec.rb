require 'spec_helper'

describe RepoFileObserver do

  let(:file) { File.open(Rails.root.join("spec", "support", "file.txt").to_s) }

  it "add/delete commit with git repo" do
    repository = Repository.make!
    repo_file = repository.repo_files.build(:repo_file => file)
    repo_file.save!
    git_repo = repo_file.git_repo
    git_repo.commits.size.should == 2
    git_repo.commits.first.message.should == "add file.txt"
    repo_file.destroy
    git_repo.commits.size.should == 3
    git_repo.commits.first.message.should == "delete file.txt"
  end

  it "update commit with git repo" do
    pending
  end
end

