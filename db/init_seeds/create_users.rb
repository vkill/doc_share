vkill = User.create!(:email => 'vkill.net@gmail.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate! if Rails.application.config.sorcery.submodules.include?(:user_activation)
vkill.save!