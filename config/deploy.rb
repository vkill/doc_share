# Load RVM's capistrano plugin.
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3@doc_share'        # Or whatever env you want it to run in.
set :rvm_type, :user

# Load bundler's capistrano plugin.
set :bundle_roles, [:app]
require "bundler/capistrano"

default_run_options[:pty]   = true # must be set for the password prompt from git to work
ssh_options[:forward_agent] = true # use local keys instead of the ones on the server

set :application, "doc_share"

set :repository, "git@github.com:vkill/doc_share.git"
set :branch, "master"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/vkill/rails_apps/#{application}"
set :deploy_via, :remote_cache


server "192.168.1.222", :app, :web, :db, :primary => true

#role :web, "127.0.0.1"                          # Your HTTP server, Apache/etc
#role :app, "127.0.0.1"                          # This may be the same as your `Web` server
#role :db,  "127.0.0.1", :primary => true # This is where Rails migrations will run
#role :db,  "127.0.0.1"

set :user, "vkill"

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
    run "cp #{shared_path}/config/resque.yml #{release_path}/config/resque.yml"
    run "cp #{shared_path}/config/smtp_settings.yml #{release_path}/config/smtp_settings.yml"
  end
end

before "deploy:assets:precompile", "deploy:copy_config_files"
before "deploy:assets:precompile", "deploy:migrate"
after "deploy:update_code", "deploy:copy_config_files"

