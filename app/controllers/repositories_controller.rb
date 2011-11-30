class RepositoriesController < ApplicationController

  before_filter :require_login, :only => [:new, :create, :reverse_watch, :fork]
  before_filter :set_current_user, :only => [:create]

  respond_to :js, :only => [:reverse_watch]

  def index
    @repositories = Repository.page(params[:page])
    respond_with @repositories
  end

  def new
    @repository = Repository.new
    respond_with @repository
  end

  def create
    @repository = Repository.new(params[:repository])
    @repository.save
    respond_with @repository, :location => user_repository_path(current_user.username, @repository.name)
  end

  def show
    @repository = User.find(params[:user]).repositories.find(params[:repository])
  end

  def watchers
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @watchers = @repository.watchers
  end

  def reverse_watch
    @target_repository = User.find(params[:user]).repositories.find(params[:repository])
    @user = current_user
    @user.watch_repository(@target_repository)
  end

  def forks
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @forks = @repository.forks
  end

  def fork
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @user = current_user
  end

end

