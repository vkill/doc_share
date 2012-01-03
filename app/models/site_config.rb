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
      SiteConfig.destroy_all
      Settings.site_configs.to_hash.each do |k,v|
        SiteConfig.create!(:key => k, :value => v)
      end
    end
  end

  after_validation :build_value
  after_save :expire_cache
  attr_accessor :best_in_place_type
  after_find do |site_config|
    site_config.send :build_best_in_place_type
  end
  
  private
    def build_value
      case self.key.to_sym
      when :site_closed
        self.value = [false, nil, 'false', 0].index(value) ? false : true
      end
    end

    def expire_cache
      self.config_hash[self.key] = self.value
    end

    def build_best_in_place_type
      self.best_in_place_type = case self.key.to_sym
      when :site_closed_description
        :textarea
      when :site_closed
        :checkbox
      else
        :input
      end
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

