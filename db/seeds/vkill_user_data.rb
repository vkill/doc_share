hyp = User.make!(:email => '122755990@qq.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
hyp.activate!
hyp.save


vkill = User.make!(:email => 'vkill.net@gmail.com', :username => 'hyphyp',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate!
vkill.save


hyp = User.find_by_email "122755990@qq.com"
vkill = User.find_by_email "vkill.net@gmail.com"
20.times {
  Message.make!(:sender => vkill, :receiver => hyp)
  Message.make!(:sender => hyp, :receiver => vkill)
}
10.times {
  Repository.make!(:user => vkill)
}

