
require "resque/tasks"
require 'resque_scheduler/tasks'

namespace :resque do
  task :setup => :environment do
  end
end
#namespace :resque do
#  task :setup do
#    load File.expand_path('../../../config/initializers/resque.rb', __FILE__)
#  end
#end
