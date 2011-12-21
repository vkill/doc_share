Settings.site_configs.to_hash.each do |k,v|
  SiteConfig.create!(:key => k, :value => v)
end
