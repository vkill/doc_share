
require 'rubygems'
require 'yaml'
require 'resque'

rails_root = File.join(File.dirname(__FILE__), "..", "..")
rails_env = ENV['RAILS_ENV'] || 'development'

redis_config = YAML.load_file(File.join(rails_root, 'config', 'redis.yml'))

Resque.redis = redis_config[rails_env]

Resque.redis.namespace = "doc_share:resque"


require 'resque/job_with_status'
Resque::Status.expire_in = (24 * 60 * 60)
require 'resque/server'
require 'resque/status_server'  #display in resque_web

require 'resque_scheduler'
Resque.schedule = YAML.load_file(File.join(rails_root, 'config', 'resque_scheduler.yml'))
require 'resque/scheduler'  #display in resque_web
