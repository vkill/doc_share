class Account::BaseController < ApplicationController

  layout 'account'
  before_filter :require_login
  authorize_namespace :namespace => Account
  before_filter :set_current_user

end

