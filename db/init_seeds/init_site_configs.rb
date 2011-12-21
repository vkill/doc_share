site_configs = {
  :site_name => "doc share",
  :site_keywords => "doc share",
  :site_default_title => "doc_share",
  :site_closed => false,
  :site_closed_description => "",
  :repositories_git_store_paths => [
    Rails.root.join("repositories_git_base1").to_s,
    Rails.root.join("repositories_git_base2").to_s
  ]
}

site_configs.each do |k,v|
  SiteConfig.create!(:key => k, :value => v)
end
