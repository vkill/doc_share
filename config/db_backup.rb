##
# Backup
# Generated Template
#
# For more information:
#
# View the Git repository at https://github.com/meskyanichi/backup
# View the Wiki/Documentation at https://github.com/meskyanichi/backup/wiki
# View the issue log at https://github.com/meskyanichi/backup/issues
#
# When you're finished configuring this configuration file,
# you can run it from the command line by issuing the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]

require 'rubygems'
require 'yaml'
require "pry"

binding.pry

RAILS_ROOT = ENV['RAILS_ROOT'] || File.expand_path('..',  __FILE__)
RAILS_ENV = ENV['RAILS_ENV'] || 'development'

database_configurations = YAML.load_file(File.expand_path('../config/database.yml',  __FILE__))

settings_env_hash = YAML.load_file(File.expand_path('../config/settings/#{RAILS_ENV}.yml',  __FILE__))
settings_hash = YAML.load_file(File.expand_path('../config/settings.yml',  __FILE__))
local_dir = settings_hash['backups_db_backup_local_dir'] || settings_env_hash['backups_db_backup_local_dir']

Backup::Model.new(:db_backup, 'Backup my database') do

  ##
  # PostgreSQL [Database]
  #
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

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path = local_dir
    local.keep = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

end

