class SiteConfig < ActiveRecord::Base

  include Redis::Objects
  hash_key :config_hash, :global => true

  serialize :value

  validates :key, :presence => true, :uniqueness => true

  #
  def self.q(key)
    self.config_hash[key]
  end

  def self.reinitialize
    SiteConfig.transaction do
      Settings.site_configs.to_hash.each do |k,v|
        site_config = SiteConfig.find_by_key!(k.to_s)
        site_config.update_attributes!(:value => v)
      end
    end
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

