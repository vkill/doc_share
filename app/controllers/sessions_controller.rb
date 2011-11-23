class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    respond_to do |format|
      if @user = login(params[:user][:email],params[:user][:password],params[:user][:remember_me])
        format.html {
          redirect_back_or_to(:users, :notice => 'Login successfull.')
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
    redirect_to(:users, :notice => 'Logged out!')
  end

end

