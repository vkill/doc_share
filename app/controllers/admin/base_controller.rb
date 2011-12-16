class Admin::BaseController < ApplicationController

  layout 'admin'

  before_filter :require_login
  before_filter :set_current_user, :only => [:create, :update]

  add_breadcrumb proc{|c| c.t("admin.navigation.main")}, :admin_root_path
  
end
