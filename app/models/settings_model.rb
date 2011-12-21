class SettingsModel
  
  def self.settings
    const
  end

  def self.update(hash)

  end

  private
    def self.const
      RailsConfig.const_get RailsConfig.const_name
    end

end