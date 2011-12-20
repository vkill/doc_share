
require 'rubygems'
require 'yaml'
require 'resque'

RAILS_ROOT = ENV['RAILS_ROOT'] || File.join(File.dirname(__FILE__), "..", "..")
RAILS_ENV = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'resque.yml'))
Resque.redis = resque_config[RAILS_ENV]

Resque.redis.namespace = "resque:vkill.net"


require 'resque/job_with_status'
Resque::Status.expire_in = (24 * 60 * 60)
require 'resque/server'
require 'resque/status_server'  #display in resque_web

require 'resque_scheduler'
Resque.schedule = YAML.load_file(File.join(RAILS_ROOT, 'config', 'resque_scheduler.yml'))
require 'resque/scheduler'  #display in resque_web
