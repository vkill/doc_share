#encoding: utf-8

Settings.site_configs.to_hash.each do |k,v|
  site_config = SiteConfig.find_or_initialize_by_key(k.to_s, :value => v)
  site_config.save!
end
