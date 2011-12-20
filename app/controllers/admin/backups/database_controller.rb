class Admin::Backups::DatabaseController < Admin::BackupsController

  add_breadcrumb proc{|c| c.t("admin.navigation.database_backups")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.navigation.database_backups")}, :admin_sql_backups_path, :except => [:index]

  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

end
