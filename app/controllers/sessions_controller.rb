class SessionsController < ApplicationController

  layout 'sign'

  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:user][:login],params[:user][:password],params[:user][:remember_me])
        format.html {
          redirect_back_or_to(root_path, :notice => 'Login successfull.')
        }
      else
        format.html {
          flash.now[:alert] = "Login failed."
          @user = User.new(params[:user])
          render :action => "new"
        }
      end
    end
  end

  def destroy
    logout
    redirect_to(root_path, :notice => 'Logged out!')
  end

end

