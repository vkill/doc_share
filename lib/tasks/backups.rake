namespace :db do
  desc "Back up the database offline"
  task :backup => :environment do
    sh "backup perform --trigger db_backup_offline --config_file config/backup_config.rb --data-path db --log-path log --tmp-path tmp"
  end
end