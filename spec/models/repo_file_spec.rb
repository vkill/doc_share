require 'spec_helper'

describe RepoFile do

  let(:file) { File.open(Rails.root.join("spec", "support", "file.txt").to_s) }
  let(:file1) { File.open(Rails.root.join("spec", "support", "file1.txt").to_s) }
  let(:file2) { File.open(Rails.root.join("spec", "support", "file2.txt").to_s) }

  context "valid_attribute" do
    it { should have_valid(:repository).when( Repository.make! ) }

    it { should have_valid(:repo_file).when( file ) }
    it { should_not have_valid(:repo_file).when(nil) }
  end

  context "validates" do
    it "uniq repo_file on one repository_id" do
      repository = Repository.make!
      RepoFile.make!(:repository => repository, :repo_file => file1)
      lambda { RepoFile.make!(:repository => repository, :repo_file => file1) }.should raise_error()
      lambda { RepoFile.make!(:repository => repository, :repo_file => file2) }.should_not raise_error()
    end
  end

end
# == Schema Information
#
# Table name: repo_files
#
#  id            :integer         not null, primary key
#  repository_id :integer
#  repo_file     :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

