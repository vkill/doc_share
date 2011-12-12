class SessionsController < ApplicationController

  layout 'sign'

  before_filter :require_login, :only => [:destroy]

  def new
    @user = User.new
  end

  def create
    if User.authenticate(params[:user][:login],params[:user][:password])
      @user = login(params[:user][:login],params[:user][:password],params[:user][:remember_me])
      redirect_to root_path, :notice => t(:notice, :scope => [:sorcery, :session, :create])
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

