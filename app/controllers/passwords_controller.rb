class PasswordsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if new_password == new_password_confirmation
      if !User.authenticate(self.username, current_password).nil?
        return self.change_password!(new_password)
      else
        return false
      end
    else
      return false
    end


    @user.password_confirmation = params[:user][:password_confirmation]
    if !User.authenticate(self.username, current_password).nil? and @user.change_password!(params[:user][:password])
      redirect_to(root_path, :notice => 'Password was successfully updated.')
    else
      render :action => "edit"
    end
  end

end

