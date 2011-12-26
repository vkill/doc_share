class Account::BaseController < ApplicationController

  layout 'account'

  before_filter :require_login
  before_filter :set_current_user, :only => [:create, :update]

  def current_ability
    @current_ability ||= AbilityAccount.new(current_user)
  end

end

