class Role < ActiveRecord::Base

  basic_attr_accessible = [:name, :code, :describtion]
  attr_accessible *(basic_attr_accessible)
  attr_accessible *(basic_attr_accessible), :as => :admin

  has_and_belongs_to_many :users, :uniq => true

  validates :name, :code, :presence => true, :uniqueness => true


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

