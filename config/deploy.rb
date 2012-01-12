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
  task :copy_config_files, :roles => [:app] do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/redis.yml #{release_path}/config/redis.yml"
    run "cp #{shared_path}/config/smtp_settings.yml #{release_path}/config/smtp_settings.yml"
  end
end

after "deploy:finalize_update", "deploy:copy_config_files"

# airbrake support
require './config/boot'
require 'airbrake/capistrano'



############# Thinking Sphinx
############# http://ayaya.tw/blog/2011/11/02/setup-thinking-sphinx-with-chinese-support/
require 'thinking_sphinx/deploy/capistrano'
namespace :deploy do
  namespace :thinking_sphinx do
    task :rebuild, :roles => :app do
      run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake ts:stop ts:rebuild"
    end
  end
  after 'deploy:restart', 'deploy:thinking_sphinx:rebuild'
end



############# resque workers and resque scheduler
############# http://balazs.kutilovi.cz/blog/2011/12/04/deploying-resque-scheduler-with-capistrano/
after "deploy:symlink", "deploy:restart_workers"
after "deploy:restart_workers", "deploy:restart_scheduler"
##
# Rake helper task.
# http://pastie.org/255489
# http://geminstallthat.wordpress.com/2008/01/27/rake-tasks-through-capistrano/
# http://ananelson.com/said/on/2007/12/30/remote-rake-tasks-with-capistrano/
def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end
namespace :deploy do
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end
  desc "Restart Resque scheduler"
  task :restart_scheduler, :roles => :db do
    run_remote_rake "resque:restart_scheduler"
  end
end