class Admin::BackupsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.backups_database")}, "", :only => [:index]

  def download
  end

  def database
  end

  def database_backup
    Rake::Task['backups:db_backup'].invoke()
    redriect_to [:database, :admin, :backups]
  end

end
