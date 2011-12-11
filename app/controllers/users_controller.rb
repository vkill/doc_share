class UsersController < ApplicationController

  layout :set_layout

  respond_to :html, :except => [:reverse_follow]
  respond_to :js, :only => [:reverse_follow]

  before_filter :require_login, :only => [:show, :edit, :update, :destroy, :password_edit, :password_update,
                                          :reverse_follow ]
  main_nav_highlight :profile, :only => [:show, :edit, :update, :destroy, :password_edit, :password_update]
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


  #########################################
  def user_page
    @user = User.find(params[:user])
    @new_activities = @user.activities.limit 30
    respond_with @user
  end

  def following
    @user = User.find(params[:user])
    @following_users = @user.following_users
    @watching_repositories = @user.watching_repositories
    respond_with @user
  end

  def followers
    @user = User.find(params[:user])
    @followers = @user.followers
    respond_with @user
  end

  def reverse_follow
    @target_user = User.find(params[:user])
    @user = current_user
    if @user.following_user? @target_user
      @user.unfollow_user(@target_user)
    else
      @follow = true
      @user.follow_user(@target_user)
    end
    respond_with @target_user
  end


  private
    def set_layout
      case params[:action]
      when 'new', 'create', 'activate'
        'sign'
      when 'show', 'edit', 'update', 'destroy', 'password_edit', 'password_update'
        'users'
      else
        'application'
      end
    end

end

