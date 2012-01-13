#encoding: utf-8

users = {
  :vkill => ["vkill", "vkill.net@gmail.com"],
  :ilttv => ["ilttv", "ilttv.cn@gmail.com"],
  :cloudbsd => ["cloudbsd", "cloudbsd@gmail.com"]
}

users.each do |name, attributes|
  puts "create #{name}... user"
  user = User.find_or_initialize_by_username(attributes[0].to_s, :email => attributes[1],
                                                            :password => '123456',
                                                            :password_confirmation => '123456'
                                                            )
  user.is_super_admin = true
  user.activate! if Rails.application.config.sorcery.submodules.include?(:user_activation)
  user.save!
  user.roles << Role.find_by_name!('admin')
end



