class Admin::RepositoriesController < Admin::ResourcesBaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.repositories")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.repositories")}, :admin_users_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Repository.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_repository_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]
  
end
