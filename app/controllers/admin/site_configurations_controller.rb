class Admin::SiteConfigurationsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.site_configurations")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configurations")}, :admin_site_configurations_path, :except => [:index]

  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  
  def index
  end

  def edit
  end

  def update
  end

end
