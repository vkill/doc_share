class SiteConfig < ActiveRecord::Base

  cattr_accessor :settings_attr_prefix, :settings_attrs
  self.settings_attr_prefix = "config"
  self.settings_attrs = []

  serialize :value

  validates :key, :presence => true, :uniqueness => true

  #
  def self.q(key)
    unless self.cache_exist?(:_wrote_cache)
      self.all.each {|site_config| self.write_cache(site_config.key, site_config.value)}
      self.write_cache(:_wrote_cache, true)
    end
    self.read_cache(key)
  end

  # build and save settings
  def self.build_settings
    settings = self.new
    self.find_each do |site_config|
      settings_attr = [self.settings_attr_prefix, site_config.key].join("_")
      self.settings_attrs << settings_attr
      self.send :attr_accessor, settings_attr
      settings.send "#{settings_attr}=", site_config.value
    end
    self.write_cache(:_settings_attrs, self.settings_attrs)
    settings.instance_variable_set :@new_record, false
    settings
  end
  def self.save_settings(values)
    settings = self.new
    self.settings_attrs = self.read_cache(:_settings_attrs)
    raise "First, please use SiteConfig.build_settings()" if self.settings_attrs.blank?
    self.settings_attrs.each do |settings_attr|
      self.send :attr_accessor, settings_attr
    end
    self.transaction do
      self.settings_attrs.each do |settings_attr|
        site_config = self.find_by_key!(settings_attr.sub(/^#{self.settings_attr_prefix}_/,""))
        site_config.update_attributes!(:value => values[settings_attr])
      end
    end
    settings
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
    def self.cache_exist?(key)
      Rails.cache.exist?(build_cache_key(key))
    end
    def self.build_cache_key(key)
      "site_config:#{key.to_s}"
    end

end
