# encoding: utf-8
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


begin
  require Rails.root.join('spec', 'support', 'blueprints')
rescue LoadError
  begin
    require Rails.root.join('test', 'blueprints')
  rescue LoadError
    raise "please execute `rails g machinist:install`"
  end
end


Dir[Rails.root.join('db', 'seeds', '*.rb').to_s].each do |file|
  puts "==  Loading #{ File.basename(file, '.rb').camelize } seed"
  load(file)
  puts "==  Done"
end

