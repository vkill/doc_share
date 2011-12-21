class SettingsModel
  
  include ActiveModel::Validations
  
  

  def self.init
    
  end

  private
    def self.rails_config_const
      RailsConfig.const_get RailsConfig.const_name
    end

end