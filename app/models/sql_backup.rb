require "ostruct"
class SqlBackup
  attr_accessor :filepath, :filename, :time, :db_name

  def initialize
    self.filepath = Rails.root.join("db/backup").to_s
    self.time = Time.zone.now
    self.filename = "#{self.time.strftime("%Y_%m_%d_%H_%M")}.sql"
    self.db_name = Settings.db_name
  end

  def dump
    system("mkdir -p #{filepath}")
    system("pg_dump -Upostgres -w #{db_name} > #{filepath}/#{filename}")
  end

  def self.all
    files = Dir.entries(self.new.filepath)
    files.delete(".")
    files.delete("..")

    files.map do |file|
      dump_at = Time.parse file.split(".").first.split("_").shift(3).join("-")
      
      OpenStruct.new(
        {
          :filename => file,
          :dump_at => dump_at
        }
      )
    end
  end

end