class Role < ActiveRecord::Base

  attr_accessible :name, :code, :describtion

  has_many :roles_users, :class_name => "RolesUsers"
  has_many :users, :through => :roles_users, :uniq => true, :dependent => :destroy

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

