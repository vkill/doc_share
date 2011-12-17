# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

vkill = User.create!(:email => 'vkill.net@gmail.com', :username => 'vkill',
                  :password => 123456, :password_confirmation => 123456)
vkill.is_super_admin = true
vkill.activate! if Rails.application.config.sorcery.submodules.include?(:user_activation)
vkill.save!