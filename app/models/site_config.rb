class SiteConfig < ActiveRecord::Base

  include Redis::Objects
  hash_key :config_hash, :global => true

  serialize :value

  validates :key, :presence => true, :uniqueness => true

  #
  def self.q(key)
    self.config_hash[key]
  end

  # build and save settings
  def self.build_settings
    settings = self.new
    SiteConfig.find_each do |site_config|
      settings_attr = [self.settings_attr_prefix, site_config.key].join("_")
      settings.send "#{settings_attr}=", site_config.value if settings.respond_to?("#{settings_attr}=")
    end
    settings.instance_variable_set :@new_record, false
    settings
  end
  def self.save_settings(values)
    settings = self.new
    SiteConfig.transaction do
      self.settings_attrs.each do |settings_attr|
        site_config = SiteConfig.find_by_key!(settings_attr.sub(/^#{self.settings_attr_prefix}_/,""))
        site_config.update_attributes!(:value => values[settings_attr])
      end
    end
    settings
  end
  def self.reinitialize
    settings = self.new
    SiteConfig.transaction do
      Settings.site_configs.to_hash.each do |k,v|
        site_config = SiteConfig.find_by_key!(k.to_s)
        site_config.update_attributes!(:value => v)
      end
    end
    settings
  end

  after_save :expire_cache
  
  private
    def expire_cache
      self.config_hash[self.key] = self.value
    end

end
# == Schema Information
#
# Table name: site_configs
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

