class SessionsController < ApplicationController

  layout 'sign'

  skip_before_filter :check_site_closed
  
  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.users")}, :users_path
  add_breadcrumb proc{|c| c.t("shared.topbar.sign_in")}, "", :only => [:new, :create]

  def new
    @user = User.new
    @ok_url = params[:ok_url]
  end

  def create
    if User.authenticate(params[:user][:login],params[:user][:password])
      @user = login(params[:user][:login],params[:user][:password],params[:user][:remember_me])
      redirect_to params[:ok_url] || root_path, :notice => t(:notice, :scope => [:sorcery, :session, :create])
    else
      @user = User.new(params[:user])
      flash[:alert] = t(:alert, :scope => [:sorcery, :session, :create])
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, :notice => t(:notice, :scope => [:sorcery, :session, :destroy])
  end

end

