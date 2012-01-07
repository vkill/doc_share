class RepositoriesController < ApplicationController

  layout :set_layout

  respond_to :html, :except => [:reverse_watch]
  respond_to :js, :only => [:reverse_watch]
  respond_to :json, :only => [:tags]

  before_filter :require_login, :only => [:reverse_watch, :fork, :admin]
  before_filter :find_repositories, :except => [:tags, :tagged]
  before_filter :find_repository, :except => [:tags, :tagged, :index, :public_repositories]
  before_filter :set_git_tag, :only => [:tree, :blob]

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.repositories")}, "", :only => [:index]

  # GET /repositories/tags.json
  def tags
    @tags = Repository.tag_counts_on(:tags).where("tags.name LIKE ?", "%#{params[:q]}%") 
    respond_to do |format|
      format.json { render :json => @tags.map(&:attributes) }
    end
  end

  # GET /repositories/tagged/tag1
  # GET /repositories/tagged/tag1+tag2
  def tagged
    if params[:tags_name]
      @repositories = Repository.includes([:user, :category]).public_repo.tagged_with(params[:tags_name].split("+")).page(params[:page])
      render :index
    else
      redirect_to [:repositories]
    end
  end

  def index
    @repositories = @repositories.order("created_at DESC").page(params[:page])
    if params[:user_username]
      render :index_by_user
    else
      render :index
    end
  end

  def watchers
    @watchers = @repository.watchers.page(params[:page])
  end

  def reverse_watch
    if current_user.watching_repository? @repository
      current_user.unwatch_repository(@repository)
    else
      @watch = true
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
    @contents = @repository.git_repo.tree(@git_tag, @tree_path).contents
  end

  def blob
    @blob_path = params[:blob_path]
    @blob = @repository.git_repo.tree(@git_tag, @blob_path).contents.first
  end

  private
    def set_layout
      case params[:action].to_sym
      when :index
        'application'
      else
        'users'
      end
    end

    def find_repositories
      if params[:user_username]
        if current_user.username === params[:user_username]
          @user = current_user
          @repositories = @user.repositories
        else
          @user = User.find_by_username!(params[:user_username])
          @repositories = @user.repositories.public_repo
        end
      else
        @repositories = Repository.includes([:user, :category]).public_repo
      end
    end

    def find_repository
      @repository = @repositories.find(params[:repository_name])
    end

    def set_git_tag
      @git_tag = params[:git_tag] || 'master'
    end

    def after_location
      user_repository_path(@user.username, @repository.name.blank? ? "x" : @repository.name)
    end

    def after_location_with_fork
      user_repository_path(current_user.username, @new_repository.name.blank? ? "x" : @new_repository.name)
    end

end

