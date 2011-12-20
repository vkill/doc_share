namespace :db do
  desc "Back up the database"
  task :backup => :environment do
    sh "backup perform --trigger db_backup --config_file config/db_backup.rb --data-path db --log-path log --tmp-path tmp"
  end
end