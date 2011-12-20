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

Backup::Model.new(:my_backup, 'My Backup') do

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    db.name               = "my_database_name"
    db.username           = "my_username"
    db.password           = "my_password"
    db.host               = "localhost"
    db.port               = 5432
    db.socket             = "/tmp/pg.sock"
    db.skip_tables        = ['skip', 'these', 'tables']
    db.only_tables        = ['only', 'these' 'tables']
    db.additional_options = ['-xc', '-E=utf8']
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
    local.path = '~/backups/'
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

