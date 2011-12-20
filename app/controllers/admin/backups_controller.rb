class Admin::BackupsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.backups_database")}, "", :only => [:index]

  def download
  end

  def database
    @files = BackupModel.db_backup_all
  end

  def database_backup
    BackupModel.perform(:db_backup)
    redriect_to [:database, :admin, :backups]
  end

end
