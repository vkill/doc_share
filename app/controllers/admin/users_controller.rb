class Admin::UsersController < Admin::ResourcesBaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.users")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.users")}, :admin_users_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]

  add_breadcrumb proc{|c| "#{User.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_user_path},
                  :except => [:index, :new, :create]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("destory")}, "", :only => [:destroy]

end
