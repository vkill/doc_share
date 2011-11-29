class RepositoriesController < ApplicationController

  before_filter :require_login, :only => [:new, :create]
  before_filter :set_current_user, :only => [:create]

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

end

