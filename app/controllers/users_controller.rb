class UsersController < ApplicationController

  layout :set_layout

  before_filter :require_login, :except => [:new, :create, :activate]
  main_nav_highlight :profile, :except => [:new, :create, :activate]
  sec_nav_highlight :show_profile, :only => [:show]
  sec_nav_highlight :edit_profile, :only => [:edit]
  sec_nav_highlight :edit_password, :only => [:password_edit]

  def new
    @user = User.new
    respond_with @user
  end

  def create
    @user = User.new(params[:user])
    @user.save
    respond_with @user, :location => [:new, :session]
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to [:new, :session], :flash => { :success => t("flash.users.activate.success") }
    else
      not_authenticated
    end
  end

  def show
    @user = current_user
    respond_with @user
  end

  def edit
    @user = current_user
    respond_with @user
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    respond_with @user, :location => current_user
  end

  def destroy
    @user = current_user
    @user.destroy
    respond_with @user, :location => root_path
  end

  def password_edit
    @user = current_user
    respond_with @user
  end

  def password_update
    @user = current_user
    @user.password_confirmation = params[:user][:password_confirmation]
    if !User.authenticate(@user.username, params[:user][:current_password]).nil? and @user.change_password!(params[:user][:password])
      logout
      redirect_to [:new, :session], :flash => { :success => t("flash.users.password_update.success") }
    else
      render :action => "password_edit"
    end
  end

  private
    def set_layout
      case params[:action]
      when 'new', 'create', 'activate'
        'sign'
      else
        'users'
      end
    end

end

