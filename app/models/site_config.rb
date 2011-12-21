class SiteConfig < ActiveRecord::Base

  cattr_accessor :wrote_cache, :built_settings, :settings_attrs, :settings_attr_prefix
  self.wrote_cache = false
  self.built_settings = false
  self.settings_attrs = []
  self.settings_attr_prefix = "config"

  serialize :value

  validates :key, :presence => true, :uniqueness => true

  #
  def self.q(key)
    self.all.each {|site_config| self.write_cache(site_config.key, site_config.value)} unless self.wrote_cache
    self.wrote_cache = true
    self.read_cache(key)
  end

  # build and save settings
  def self.build_settings
    settings = self.new
    self.find_each do |site_config|
      settings_attr = [self.settings_attr_prefix, site_config.key].join("_")
      unless self.built_settings
        self.settings_attrs << settings_attr
        self.send :attr_accessor, settings_attr
      end
      settings.send "#{settings_attr}=", site_config.value
    end
    self.built_settings = true
    settings
  end
  def save_settings
    raise "First, please use SiteConfig.build_settings()" if self.settings_attrs.blank?
    self.class.transaction do
      self.class.settings_attrs.each do |settings_attr|
        site_config = self.class.find_by_key!(settings_attr.sub(/#{self.class.settings_attr_prefix}_/,""))
        site_config.update_attributes!(:value => self.send(settings_attr))
      end
    end
  end

  after_save :expire_cache
  
  private
    def expire_cache
      self.class.write_cache(self.key, self.value)
    end

    def self.write_cache(key, value)
      Rails.cache.write(build_cache_key(key), value)
    end
    def self.read_cache(key)
      Rails.cache.read(build_cache_key(key))
    end
    def self.build_cache_key(key)
      "site_config:#{key.to_s}"
    end

end
