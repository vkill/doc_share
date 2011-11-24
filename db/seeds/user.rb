
10.times do
  User.make!
end

vkill = User.make!(:email => '122755990@qq.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate!
vkill.save

