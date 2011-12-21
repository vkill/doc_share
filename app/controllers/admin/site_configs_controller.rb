class Admin::SiteConfigsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.site_configs")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.site_configs")}, :admin_site_configs_path, :except => [:index]

  add_breadcrumb proc{|c| "#{SiteConfig.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_site_config_path},
                  :except => [:index]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

  def index
  end

  def edit
  end

  def update
  end

end
