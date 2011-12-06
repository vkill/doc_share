require 'spec_helper'

describe RepoFile do

  context "valid_attribute" do
    it { should have_valid(:repository).when( Repository.make! ) }

    it { should have_valid(:repo_file).when( File.open(__FILE__)) }
    it { should_not have_valid(:repo_file).when(nil) }
  end

  context "validates" do
    it "uniq repo_file on one repository_id" do
      repository = Repository.make!
      RepoFile.make!(:repository => repository, :repo_file => File.open(Rails.root.join("config.ru").to_s))
      lambda { RepoFile.make!(:repository => repository, :repo_file => File.open(Rails.root.join("config.ru").to_s)) }.should raise_error()
      lambda { RepoFile.make!(:repository => repository, :repo_file => File.open(Rails.root.join("Gemfile").to_s)) }.should_not raise_error()
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

