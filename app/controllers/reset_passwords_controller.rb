class ResetPasswordsController < ApplicationController

  layout 'sign'

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.valid?
    if @user.errors[:email].blank?
      user = User.find_by_email(params[:user][:email])
      if user.blank?
        @user.errors.add(:email, t(:email_not_found, :scope => [:sorcery, :reset_password]))
        render :new
      else
        user.deliver_reset_password_instructions!
        redirect_to signin_path, :notice => t(:notice, :scope => [:sorcery, :reset_password, :create])
      end
    else
      render :new
    end
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @user.reset_password_token = params[:id]
    not_authenticated if !@user
  end

  def update
    @token = params[:user][:reset_password_token]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if !@user
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to signin_path, :notice => t(:notice, :scope => [:sorcery, :reset_password, :update])
    else
      render :edit
    end
  end

end

