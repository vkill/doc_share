require "ostruct"
class SqlBackup
  def dump
    Rake::Task['db:backup'].invoke()
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