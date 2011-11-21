require 'spec_helper'

describe Role do

  context "valid_attribute" do

    before { Role.create(:name => 'test', :code => 'test') }

    it { should have_valid(:users).when( [User.make!] ) }

    it { should have_valid(:name).when('test_123') }
    it { should_not have_valid(:name).when(nil, 'test') }
    it { should have_valid(:code).when('test_123') }
    it { should_not have_valid(:code).when(nil, 'test') }
  end

end
# == Schema Information
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  code        :string(255)
#  describtion :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

