require 'spec_helper'

describe Category do

  context "valid_attribute" do

    before { Category.create(:name => 'test', :code => 'test') }

    it { should have_valid(:repositories).when([ Repository.make! ]) }

    it { should have_valid(:name).when('test_123') }
    it { should_not have_valid(:name).when(nil, 'test') }
    it { should have_valid(:code).when('test_123') }
    it { should_not have_valid(:code).when(nil, 'test') }

  end

end
# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  ancestry   :string(255)
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

