# encoding: utf-8

begin
  require 'database_cleaner'
rescue LoadError
  ActiveRecord::Base.send :include, VkillGemsMethods::ActiveRecord::Base
  ActiveRecord::Base.models do |model|
    model.delete_all
  end
else
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end

begin
  require Rails.root.join('spec', 'support', 'blueprints')
rescue LoadError
  begin
    require Rails.root.join('test', 'blueprints')
  rescue LoadError
    raise "please execute `rails g machinist:install`"
  end
end

load Rails.root.join("db", "production_seeds", "init_site_configs.rb")

Dir[Rails.root.join('db', 'seeds', '*.rb').to_s].each do |file|
  puts "==  Loading #{ File.basename(file, '.rb').camelize } seed"
  load(file)
  puts "==  Done"
end

