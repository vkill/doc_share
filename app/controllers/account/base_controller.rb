class Account::BaseController < ApplicationController

  layout 'admin'

  before_filter :require_login
  before_filter :set_current_user

end

