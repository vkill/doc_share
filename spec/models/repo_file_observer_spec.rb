require 'spec_helper'

describe RepoFileObserver do

  let(:file) { File.open(Rails.root.join("spec", "support", "file.txt").to_s) }

  it "add/delete commit with git repo" do
    repository = Repository.make!
    repo_file = repository.repo_files.create!(:repo_file => file)
    repo = Grit::Repo.new repo_file.git_repo_path
    repo.commits.size.should == 2
    repo.commits.first.message.should == "add file.txt"
    repo_file.destroy
    repo.commits.size.should == 3
    repo.commits.first.message.should == "delete file.txt"
  end

  it "update commit with git repo" do
    pending
  end
end

