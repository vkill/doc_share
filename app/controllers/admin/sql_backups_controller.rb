class Admin::SqlBackupsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.sql_backups")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.sql_backups")}, :admin_sql_backups_path, :except => [:index]

  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  
  def index
  end

  def create
  end

end
