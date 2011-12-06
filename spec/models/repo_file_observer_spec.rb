require 'spec_helper'

describe RepoFileObserver do
  it "add file to git repo" do
    repository = Repository.make!
    repo_file = repository.repo_files.create!(:repo_file => File.open(Rails.root.join("config.ru").to_s))
    repo = Grit::Repo.new repo_file.git_repo_path
    repo.commits.size.should == 2
    repo.commits.last.message.should == "add config.ru"
    repo_file.destroy
    repo.commits.size.should == 3
    repo.commits.last.message.should == "delete config.ru"
  end
end

