class RepositoriesController < ApplicationController

  def index
    @repositories = Repository.page(params[:page])
    respond_with @repositories
  end

  def new
    @repository = Repository.new
    respond_with @repository
  end

  def create
    @repository = Repository.new(params[:message])
    @repository.save
    respond_with @repository, :location => root_path
  end

end

