class Admin::BackupsController < Admin::BaseController

  add_breadcrumb proc{|c| c.t("admin.navigation.backups_databases")}, "", :only => [:databases]

  def download
    send_file BackupModel.build_path(params[:path])
  end

  def delete
    BackupModel.delete(params[:path])
    redirect_to :back
  end

  def databases
    @files = BackupModel.db_backup_all
  end

  def backup_database
    BackupModel.perform(:db_backup)
    redirect_to [:databases, :admin, :backups]
  end

end
