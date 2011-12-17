class Admin::CategoriesController < Admin::ResourcesBaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.categories")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.categories")}, :admin_users_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Category.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_category_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]
end
