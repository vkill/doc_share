class RolesUsers < ActiveRecord::Base

  set_table_name "roles_users"

  belongs_to :user
  belongs_to :role

end# == Schema Information
#
# Table name: roles_users
#
#  role_id :integer
#  user_id :integer
#

