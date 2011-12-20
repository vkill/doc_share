namespace :db do
  desc "Back up the database offline"
  task :backup => :environment do
    sh "backup perform --trigger db_backup --config_file config/backup_config.rb --data-path backups --log-path log --tmp-path tmp"
  end
end