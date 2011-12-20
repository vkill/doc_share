class Admin::BackupsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.backups_databases")}, "", :only => [:databases]

  def download
  end

  def delete
  end

  def databases
    @files = BackupModel.db_backup_all
  end

  def backup_database
    BackupModel.perform(:db_backup)
    redirect_to [:databases, :admin, :backups]
  end

end
