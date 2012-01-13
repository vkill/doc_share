#encoding: utf-8

roles = [
  [:admin, "管理员"]
]

roles.each do |role_attributes|
  puts "create #{role_attributes[0]}..."
  role = Role.find_or_initialize_by_username(role_attributes[0].to_s, :code => role_attributes[1])
  role.save!
end
