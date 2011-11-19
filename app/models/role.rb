class Role < ActiveRecord::Base

  has_and_belongs_to_many :users, :join_table => :roles_users, :uniq => true

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

