class Admin::UsersController < Admin::BaseController

  before_filter :find_or_build_user, :except => [:index]

  add_breadcrumb :users, "", :only => [:index]

  add_breadcrumb :users, :admin_users_path, :except => [:index]
  add_breadcrumb proc{|c| "user##{ c.params[:id] }"}, proc{|c| c.admin_user_path}, :except => [:index]
  add_breadcrumb :show, "", :only => [:show]
  add_breadcrumb :edit, "", :only => [:edit]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  private
    def find_or_build_user
      @user = params[:id] ? User.find(params[:id]) : User.new(params[:user])
    end

end
