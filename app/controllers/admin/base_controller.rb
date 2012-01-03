class Admin::BaseController < ApplicationController

  layout 'admin'

  before_filter :require_login
  skip_before_filter :check_site_closed

  add_breadcrumb proc{|c| c.t("admin.shared.topbar.main")}, :admin_root_path
  
  
  protected

    def current_ability
      @current_ability ||= AbilityAdmin.new(current_user)
    end

end
