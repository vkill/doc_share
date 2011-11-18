namespace :app do
  namespace :dev do
    desc "recreates the development database from migration, and updates the db schema if necessary"
    task :reload => :environment do
      puts "running rake db:drop"
      Rake::Task['db:drop'].invoke

      puts "running rake db:create"
      Rake::Task['db:create'].invoke

      puts "running rake db:migrate"
      Rake::Task['db:migrate'].invoke

      puts "running seeds_for_dev"
      load Rails.root.join('db', 'seeds_for_dev.rb').to_s

      puts "running rake db:test:clone"
      Rake::Task['db:test:clone'].invoke
    end

    desc "alias as app:dev:reload"
    task :init => :reload

  end if Rails.env.development?
end

