class RepositoriesController < ApplicationController

  respond_to :html, :except => [:reverse_watch]
  respond_to :js, :only => [:reverse_watch]

  before_filter :require_login, :only => [:new, :create, :reverse_watch, :fork, :private_repositories,
                                          :edit, :update]
  before_filter :set_current_user, :only => [:create]

  def index
    @repositories = Repository.page(params[:page])
    respond_with @repositories
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])
    @repository.save
    respond_with @repository, :location => user_repository_path(current_user.username, @repository.name.blank? ? "x" : @repository.name)
  end

  def edit
    @repository = current_user.repositories.find(params[:id])
  end

  def update
    @repository = current_user.repositories.find(params[:id])
    @repository.update_attributes(params[:repository])
    respond_with @repositories, :location => user_repository_path(current_user.username, @repository.name.blank? ? "x" : @repository.name)
  end

  def add_repo_file
    @repository = current_user.repositories.find(params[:id])
    @repository.repo_files.build if @repository.repo_files.blank?
  end

  def show
    @repository = User.find(params[:user]).repositories.find(params[:repository])
  end

  def watchers
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @watchers = @repository.watchers.page(params[:page])
  end

  def reverse_watch
    @target_repository = User.find(params[:user]).repositories.find(params[:repository])
    @user = current_user
    if @user.watching_repository? @target_repository
      @user.unwatch_repository(@target_repository)
    else
      @user.watch_repository(@target_repository)
      @watch = true
    end
    respond_with @target_repository
  end

  def forks
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @forks = @repository.forks
  end

  def fork
    @repository = User.find(params[:user]).repositories.find(params[:repository])
    @user = current_user
    @new_repository = @repository.fork_by!(@user)
    respond_with @new_repository, :location => user_repository_path(@user.username, @new_repository.name)
  end

  def public_repositories
    @user = User.find(params[:user])
    @repositories = @user.repositories.page(params[:page])
    respond_with @repositories
  end

  def private_repositories
    @user = current_user
    @repositories = @user.repositories.page(params[:page])
    respond_with @repositories
  end

end

