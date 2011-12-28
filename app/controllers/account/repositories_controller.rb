class Account::RepositoriesController < Account::BaseController

  main_nav_highlight :repositories

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.profile_center")}, :account_root_path

  add_breadcrumb proc{|c| c.t("account.shared.navigation.repositories")}, :account_repositories_path
  
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]

  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]                  

  before_filter :find_or_build_repository, :except => [:index]

  def index
    @user = current_user
    @q = current_user.repositories.ransack(params[:q])
    @repositories = @q.result().page(params[:page])
  end

  def new
  end

  def create
    @repository.save
    respond_with :account, @repository, :location => after_location
  end

  def edit
  end

  def update
    @repository.update_attributes(params[:repository])
    respond_with :account, @repository, :location => after_location
  end

  def destroy
    @repository.destroy
    respond_with :account, @repository
  end

  private
    def find_or_build_repository
      @repository = params[:id] ? current_user.repositories.find(params[:id]) : current_user.repositories.build(params[:repository])
    end

    def after_location
      user_repository_path(current_user.username, @repository.name.blank? ? "x" : @repository.name)
    end

end

