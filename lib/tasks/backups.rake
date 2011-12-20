namespace :backups
  desc "Backup the database"
  task :db_backup => :environment do
    sh "backup perform --trigger db_backup --config_file config/backup_config.rb --data-path backups --log-path log --tmp-path tmp"
  end
end

namespace :db do
  task :backup => "backups::db_backup"
end