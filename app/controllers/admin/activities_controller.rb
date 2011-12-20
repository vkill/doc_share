class Admin::ActivitiesController < Admin::ResourcesBaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.activities")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.activities")}, :admin_activities_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export_all")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Activity.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_activity_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]
end
