class UsersController < ApplicationController
  inherit_resources
  actions :all, :except => [:index]

  def create
    create! do |success, failure|
      success.html { redirect_to resource_url, :notice => t(:signup_successful) }
      failure.html { render :new }
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end

  protected
    def begin_of_association_chain
      current_user
    end

end

