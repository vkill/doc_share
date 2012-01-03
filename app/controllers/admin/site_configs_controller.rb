class Admin::SiteConfigsController < Admin::ResourcesBaseController
  
  add_breadcrumb proc{|c| c.t("admin.shared.topbar.site_configs")}, "", :only => [:index]

  def update
    @site_config.assign_attributes(params[:site_config], :as => :admin)
    respond_to do |format|
      if @site_config.save
        format.html { redirect_to :admin, :site_configs }
        format.json { respond_with_bip(@site_config) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@site_config) }
      end
    end
  end

  def reinitialize
    SiteConfig.reinitialize()
    redirect_to [:admin, :site_configs], :notice => t(:successfully_completed)
  end

end