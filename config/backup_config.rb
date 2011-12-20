
require 'yaml'

RAILS_ROOT = File.expand_path('..',  __FILE__)
RAILS_ENV = ENV['RAILS_ENV'] || 'development'

database_configurations = YAML.load_file(File.join(RAILS_ROOT, "/config/database.yml"))

backup_store_local_dir = File.join(RAILS_ROOT, "/backups")

Backup::Model.new(:db_backup, 'Backup my database offline') do

  database PostgreSQL do |db|
    db.name               = database_configurations[RAILS_ENV]["database"]
    db.username           = database_configurations[RAILS_ENV]["username"]
    db.password           = database_configurations[RAILS_ENV]["password"]
    db.host               = database_configurations[RAILS_ENV]["host"]
    db.port               = database_configurations[RAILS_ENV]["port"]
    # db.socket             = "/tmp/pg.sock"
    db.skip_tables        = []
    # db.only_tables        = []
    db.additional_options = ['-xc', '-E=utf8']
  end

  store_with Local do |local|
    local.path = backup_store_local_dir
    local.keep = 5
  end

  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

end

