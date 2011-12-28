
require 'rubygems'
require 'yaml'
require "redis"
require "redis-namespace"
require "redis-search"

RAILS_ROOT = File.join(File.dirname(__FILE__), "..", "..")
RAILS_ENV = ENV['RAILS_ENV'] || 'development'

redis_config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'redis.yml'))

Resque.redis = redis_config[RAILS_ENV].split(":")

redis = Redis.new(:host => redis_host,:port => redis_port)
redis.select(3)
redis = Redis::Namespace.new("doc_share:redis_search", :redis => redis)

Redis::Search.configure do |config|
  config.redis = redis
  config.complete_max_length = 100
  config.pinyin_match = true
end