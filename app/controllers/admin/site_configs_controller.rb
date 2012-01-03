class Admin::SiteConfigsController < Admin::ResourcesBaseController
  
  add_breadcrumb proc{|c| c.t("admin.shared.topbar.site_configs")}, "", :only => [:index]

  def reinitialize
    @site_config = SiteConfig.reinitialize()
    redirect_to [:admin, :site_configs], :notice => t(:successfully_completed)
  end

end