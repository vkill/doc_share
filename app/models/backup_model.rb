class BackupModel
  @@backup_store_local_path = Rails.root.join("backups").to_s

  def self.db_backup_all
    Dir[Rails.root.join("backups/db_backup/*.tar.gz")].map do |path|
      OpenStruct.new(
        {
          :filename => path,
          :backup_at => path.sub(/.db_backup.tar.gz/, "")
        }
      )
    end
  end

  def self.perform(trigger)
    case trigger.to_sym
    when :db_backup
      Rake::Task['backups:db_backup'].invoke()
    end
  end
end