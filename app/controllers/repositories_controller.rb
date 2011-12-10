class RepositoriesController < ApplicationController

  respond_to :html, :except => [:reverse_watch]
  respond_to :js, :only => [:reverse_watch]

  before_filter :require_login, :only => [:reverse_watch, :fork, :admin]
  before_filter :find_user_public_repositories, :except => [:index]
  before_filter :find_repository, :except => [:index, :public_repositories]
  before_filter :set_tag, :only => [:tree, :blob]

  def index
    @repositories = Repository.public_repo.page(params[:page])
  end

  def public_repositories
    @repositories = @repositories.page(params[:page])
  end

  def watchers
    @watchers = @repository.watchers.page(params[:page])
  end

  def reverse_watch
    if current_user.watching_repository? @repository
      current_user.unwatch_repository(@repository)
    else
      current_user.watch_repository(@repository)
    end
    respond_with @repository, :location => after_location
  end

  def forks
    @forks = @repository.forks.page(params[:page])
  end

  def fork
    @new_repository = @repository.fork_by!(current_user)
    respond_with @new_repository, :location => after_location_with_fork
  end

  def admin
    raise "" unless @user == current_user
    @repo_file = @repository.repo_files.build()
  end

  def tree
    @tree_path = params[:tree_path]
    @contents = @repository.git_repo.tree(@tag, @tree_path).contents
  end

  def blob
    @blob_path = params[:blob_path]
    @blob = @repository.git_repo.tree(@tag, @blob_path).contents.first
  end

  private
    def find_user_public_repositories
      @user = User.find(params[:user])
      @repositories = @user.repositories.public_repo
    end

    def find_repository
      @repository = @repositories.find(params[:repository])
    end

    def set_tag
      @tag = params[:tag] || 'master'
    end

    def after_location
      user_repository_path(@user.username, @repository.name.blank? ? "x" : @repository.name)
    end

    def after_location_with_fork
      user_repository_path(current_user.username, @new_repository.name.blank? ? "x" : @new_repository.name)
    end

end

