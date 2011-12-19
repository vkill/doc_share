class Admin::BaseController < ApplicationController

  layout 'admin'

  before_filter :require_login
  
  add_breadcrumb proc{|c| c.t("admin.navigation.main")}, :admin_root_path
  
end
