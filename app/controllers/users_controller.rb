class UsersController < ApplicationController

  layout :set_layout

  respond_to :html, :except => [:activate, :autocomplete_with_username, :reverse_follow]
  respond_to :json, :only => [:autocomplete_with_username]
  respond_to :js, :only => [:reverse_follow]

  sorcery_actions = [:show, :edit, :update, :destroy, :password_update]

  before_filter :require_login, :only => sorcery_actions + [:autocomplete_with_username, :reverse_follow]
  before_filter :set_user, :only => sorcery_actions
  before_filter :find_user, :only => [:user_page, :following, :followers, :reverse_follow]

  main_nav_highlight :profile, :only => sorcery_actions

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.users")}, :users_path, :only => [:index, :new, :create]
  add_breadcrumb proc{|c| c.t("shared.topbar.sign_up")}, "", :only => [:new, :create]

  add_breadcrumb proc{|c| c.t("shared.topbar.profile_center")}, proc{|c| c.account_root_path}, :only => sorcery_actions
  add_breadcrumb proc{|c| c.t("shared.topbar.edit_profile")}, "", :only => sorcery_actions

  main_nav_highlight :users, :only => [:index]


  #################################################################
  # don't require login
  #################################################################

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if Rails.application.config.sorcery.submodules.include?(:user_activation)
        redirect_to [:new, :session], :notice => t(:notice_activate, :scope => [:sorcery, :user, :create])
      else
        redirect_to [:new, :session], :notice => t(:notice, :scope => [:sorcery, :user, :create])
      end
    else
      render :new
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to [:new, :session], :notice => t(:notice, :scope => [:sorcery, :user, :activate])
    else
      not_authenticated
    end
  end

  def user_page
    if current_user == @user
      @latest_repositories = @user.repositories
    else
      @latest_repositories = @user.repositories.public_repo
    end
    @latest_repositories = @latest_repositories.limit(5).order('updated_at DESC')
    @latest_activities = @user.activities.limit(15).order('created_at DESC')
  end

  def following
    @following_users = @user.following_users.page(params[:page])
    @watching_repositories = @user.watching_repositories.page(params[:page])
  end

  def followers
    @followers = @user.followers.page(params[:page])
  end

  #################################################################
  # require login
  #################################################################

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      if params[:user][:setting_user_notification_attributes].present?
        redirect_to [:account, :notifications_center], :notice => t(:notice_notification, :scope => [:sorcery, :user, :update])
      else
        redirect_to [:edit, @user], :notice => t(:notice, :scope => [:sorcery, :user, :update])
      end
    else
      if params[:user][:setting_user_notification_attributes].present?
        render :edit
      else
        render :template => "account/main/notifications_center"
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, :notice => t(:notice, :scope => [:sorcery, :user, :destroy])
  end

  def password_update
    @user.password_confirmation = params[:user][:password_confirmation]
    if !User.authenticate(@user.username, params[:user][:current_password]).nil? and @user.change_password!(params[:user][:password])
      logout
      redirect_to [:new, :session], :notice => t(:notice, :scope => [:sorcery, :user, :password_update])
    else
      @user.valid?
      render :edit
    end
  end

  ###################
  # autocomplete request
  def autocomplete_with_username
    @users = User.ransack(:username_cont => params[:q]).result().select([:username, :email]).limit(10)
    respond_with @users do |format|
      format.json { render :json => @users.map{|user| {:username => user.username,
                                                      :gravatar_url => user.gravatar_url(:size => 20) } } }
    end
  end

  def reverse_follow
    if current_user.following_user? @user
      current_user.unfollow_user(@user)
    else
      @follow = true
      current_user.follow_user(@user)
    end
  end






  private
    def set_layout
      case params[:action].to_sym
      when :autocomplete_with_username
        nil
      when :index
        'application'
      when :new, :create
        'sign'
      when :activate
        nil
      when :user_page, :following, :followers
        'users'
      when :show, :edit, :update, :destroy, :password_update
        'account'
      when :reverse_follow
        nil
      end
    end

    def set_user
      @user = current_user
    end
    
    def find_user
      @user = User.find_by_username!(params[:user_username])
    end
end

