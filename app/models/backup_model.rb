require "fileutils"
class BackupModel
  @@backup_store_local_path = Rails.root.join("backups").to_s

  def self.all_db_backup
    Dir[File.join(@@backup_store_local_path, "/db_backup/*.tar.gz")].map do |path|
      OpenStruct.new(
        {
          :filepath => path,
          :backup_at => File.basename(path).sub(/.db_backup.tar.gz/, "")
        }
      )
    end
  end

  def self.delete(path)
    FileUtils.rm build_path(path)
  end

  def self.build_path(path)
    File.join(@@backup_store_local_path, path.sub(/^#{@@backup_store_local_path}/, ""))
  end

  def self.perform(trigger)
    case trigger.to_sym
    when :db_backup
      system( %Q` rake backups:db_backup RAILS_ENV="#{Rails.env}" `)
    end
  end
end