require 'spec_helper'

describe RepoFile do

  context "valid_attribute" do
    it { should have_valid(:repository).when( Repository.make! ) }

    it { should have_valid(:repo_file).when( File.open(__FILE__)) }
    it { should_not have_valid(:repo_file).when(nil) }
  end

end
# == Schema Information
#
# Table name: repo_files
#
#  id            :integer         not null, primary key
#  repository_id :integer
#  file          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

