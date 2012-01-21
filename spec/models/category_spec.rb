require 'spec_helper'

describe Category do

  subject { Category.make!() }
  let(:parent_category) { Category.make!(:name => "parent_#{object_id}", :code => "parent_#{object_id}") }
  let(:child_category) { Category.make!(:name => "child_#{object_id}", :code => "child_#{object_id}",
                                        :parent => parent_category) }

  context "shoulda" do
    it { should have_many(:repositories) }

    it { should allow_mass_assignment_of(:parent).as(:admin) }
    it { should allow_mass_assignment_of(:name).as(:admin) }
    it { should allow_mass_assignment_of(:code).as(:admin) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    context "uniqueness" do
      before(:each) { Category.create(:name => 'category_name', :code => 'category_code') }
      it { should validate_uniqueness_of(:name) }
      it { should validate_uniqueness_of(:code) }
    end

    it { should allow_mass_assignment_of(:parent) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:code) }
    it { should allow_mass_assignment_of(:parent).as(:admin) }
    it { should allow_mass_assignment_of(:name).as(:admin) }
    it { should allow_mass_assignment_of(:code).as(:admin) }
  end

  context "scopes" do
    it { Category.random(1).first.should be_kind_of(Category) }
    it { Category.parents.should include(parent_category) }
    it { Category.children.should include(child_category) }
  end

  context "methods" do
    it "should has self.list" do
      parent_category.reload
      list = Category.list
      list.keys.should include(parent_category)
      list[parent_category].should include(child_category)
    end

    it "should has parent?" do
      parent_category.parent?.should be_true
      child_category.parent?.should be_false
    end
  end
end
# == Schema Information
#
# Table name: categories
#
#  id                 :integer         not null, primary key
#  ancestry           :string(255)
#  name               :string(255)
#  code               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  repositories_count :integer
#

