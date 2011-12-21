class Admin::SiteConfigsController < Admin::BaseController
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configs")}, :admin_site_configs_path

  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

  def show
  end

  def edit
  end

  def update
  end

end
