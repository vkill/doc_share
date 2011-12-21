class SiteConfig < ActiveRecord::Base

  cattr_accessor :wrote_cache

  serialize :value

  validates :key, :presence => true, :uniqueness => true

  def self.q(key)
    unless self.wrote_cache
      SiteConfig.all.each {|site_config| self.write_cache(site_config.key, site_config.value)}
      self.wrote_cache = true
    end
    read_cache(key)
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
