class Admin::SiteConfigsController < Admin::BaseController
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configs")}, :admin_site_configs_path

  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

  def show
    @site_configs = SiteConfig.build_settings()
  end

  def edit
    @site_configs = SiteConfig.build_settings()
  end

  def update
    @site_configs = SiteConfig.new(params[:site_configs])
    @site_configs.save_settings()
    respond_with :admin, @site_configs
  end

end
