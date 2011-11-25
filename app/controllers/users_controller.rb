class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :activate]
  layout :set_layout

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to([:new, :session], :notice => 'Registration successfull. Check your email for activation instructions.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to([:new, :session], :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end

  def show
    @user = current_user
    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(root_path) }
    end
  end

  def password_edit
    @user = current_user
  end

  def password_update
    @user = current_user

    @user.password_confirmation = params[:user][:password_confirmation]
    if !User.authenticate(@user.username, params[:user][:current_password]).nil? and @user.change_password!(params[:user][:password])
      redirect_to([:new, :session], :notice => 'Password was successfully updated.')
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
        'application'
      end
    end

end

