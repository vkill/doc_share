
rails_root = File.join(File.dirname(__FILE__), "..", "..")
rails_env = ENV['RAILS_ENV'] || 'development'

redis_config = YAML.load_file(File.join(rails_root, 'config', 'redis.yml'))

host, port = redis_config[rails_env].split(":")

require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new(:host => host, :port => port)