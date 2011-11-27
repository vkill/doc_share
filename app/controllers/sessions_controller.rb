class SessionsController < ApplicationController

  before_filter :require_login, :only => [:destroy]
  layout 'sign'

  def new
    @user = User.new
    respond_with @user
  end

  def create
    if User.authenticate(params[:user][:login],params[:user][:password])
      @user = login(params[:user][:login],params[:user][:password],params[:user][:remember_me])
    else
      @user = User.new(params[:user])
      @user.errors.add(:base, "login failed.")
    end
    respond_with @user, :location => root_path
  end

  def destroy
    logout
    redirect_to root_path, :flash => { :success => t("flash.sessions.destroy.success") }
  end

end

