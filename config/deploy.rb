# Load RVM's capistrano plugin.
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3@doc_share'        # Or whatever env you want it to run in.
set :rvm_type, :user


# Load bundler's capistrano plugin.
set :bundle_roles, [:app]
require "bundler/capistrano"


set :application, "doc_share"

set :repository, "git@github.com:vkill/doc_share.git"
set :branch, "master"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/railsapp/rails_apps/#{application}"
set :deploy_via, :remote_cache


server "58.215.184.38", :app, :web, :db, :primary => true
#or
#role :web, "127.0.0.1"                          # Your HTTP server, Apache/etc
#role :app, "127.0.0.1"                          # This may be the same as your `Web` server
#role :db,  "127.0.0.1", :primary => true # This is where Rails migrations will run
#role :db,  "127.0.0.1"

set :user, "railsapp"

set :use_sudo, false


# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


# copy config files
namespace :deploy do
  task :copy_config_files, :roles => [:app] do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/redis.yml #{release_path}/config/redis.yml"
    run "cp #{shared_path}/config/smtp_settings.yml #{release_path}/config/smtp_settings.yml"
  end
end
after "deploy:finalize_update", "deploy:copy_config_files"



# db:seed
namespace :deploy do
  namespace :db do
    task :seed, :roles => [:db] do
      run_remote_rake "db:seed"
    end
  end
end


# airbrake support
require './config/boot'
require 'airbrake/capistrano'

############# resque workers and resque scheduler
############# http://balazs.kutilovi.cz/blog/2011/12/04/deploying-resque-scheduler-with-capistrano/
# after "deploy:start", "deploy:start_workers"
after "deploy:stop", "deploy:stop_workers"
after "deploy:restart", "deploy:restart_workers"

# after "deploy:start", "deploy:start_scheduler"
after "deploy:stop", "deploy:stop_scheduler"
after "deploy:restart", "deploy:restart_scheduler"

def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end
namespace :deploy do
  task :start_workers, :roles => :db do
    run_remote_rake "resque:start_workers"
  end
  task :stop_workers, :roles => :db do
    run_remote_rake "resque:stop_workers"
  end
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end
  
  task :start_scheduler, :roles => :db do
    run_remote_rake "resque:start_scheduler"
  end
  task :stop_scheduler, :roles => :db do
    run_remote_rake "resque:stop_scheduler"
  end
  task :restart_scheduler, :roles => :db do
    run_remote_rake "resque:restart_scheduler"
  end
end

############# Thinking Sphinx
# after 'deploy:start', 'deploy:start_thinking_sphinx'
after 'deploy:stop', 'deploy:stop_thinking_sphinx'
after 'deploy:restart', 'deploy:restart_thinking_sphinx'
namespace :deploy do
  task :start_thinking_sphinx, :roles => :db do
    run_remote_rake "ts:config"
    run_remote_rake "ts:index"
    run_remote_rake "ts:run"
  end
  task :stop_thinking_sphinx, :roles => :db do
    run_remote_rake "ts:stop"
  end
  task :restart_thinking_sphinx, :roles => :db do
    run_remote_rake "ts:config"
    run_remote_rake "ts:reindex"
    run_remote_rake "ts:run"
  end
end
