class Account::RepositoriesController < Account::BaseController

  before_filter :find_or_build_repository, :except => [:index]

  def index
    @q = current_user.repositories.search(params[:q])
    @repositories = @q.result().page(params[:page])
  end

  def new
  end

  def create
    @repository.save
    respond_with @repository, :location => after_location
  end

  def edit
  end

  def update
    @repository.update_attributes(params[:repository])
    respond_with @repository, :location => after_location
  end

  def destroy
    @repository.destroy
    respond_with @repository
  end

  def manage
  end

  private
    def find_or_build_repository
      @repository = params[:id] ? current_user.repositories.find(params[:id]) : current_user.repositories.build(params[:repository])
    end

    def after_location
      user_repository_path(current_user.username, @repository.name.blank? ? "x" : @repository.name)
    end

end

