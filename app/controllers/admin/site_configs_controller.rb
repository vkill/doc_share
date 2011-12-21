class Admin::SiteConfigsController < Admin::BaseController
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configs")}, :admin_site_config_path

  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

  def show
    @site_config = SiteConfig.build_settings()
  end

  def edit
    @site_config = SiteConfig.build_settings()
  end

  def update
    @site_config = SiteConfig.save_settings(params[:site_config])
    redirect_to [:admin, :site_config]
  end

end