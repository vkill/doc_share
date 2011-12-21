class Admin::SiteConfigurationsController < Admin::BaseController
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configurations")}, :edit_admin_site_configurations_path, :except => [:index]

  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  
  def edit
  end

  def update
  end

end
