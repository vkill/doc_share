# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

load Rails.root.join("db", "production_seeds", "init_site_configs.rb")
load Rails.root.join("db", "production_seeds", "create_roles.rb")
load Rails.root.join("db", "production_seeds", "create_users.rb")
load Rails.root.join("db", "production_seeds", "create_categories.rb")
