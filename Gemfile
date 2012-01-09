source 'http://ruby.taobao.org'

gem 'rails', '3.1.3'

group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem "jquery-rails"
gem "therubyracer", "~> 0.9.9", :require => "v8"

#gem "yajl-ruby", "~> 1.1.0", :require => "yajl"
gem "nokogiri", "~> 1.5.0"

gem "eventmachine", "~> 1.0.0.beta.4"
gem "resque", "~> 1.19.0"
gem "redis-store", "~> 1.0.0.1"
gem "resque-status", "~> 0.2.4"
gem "resque-scheduler", "~> 1.9.9"
gem "resque_mailer", "~> 2.0.2"
gem "redis-objects", "~> 0.5.2"

gem "rails-i18n", "~> 0.1.10"

gem "sorcery", "~> 0.7.5"
gem "cancan", :git => "git://github.com/ryanb/cancan.git", :branch => "2.0"

gem "rails_config", "~> 0.2.5"

#gem "inherited_resources", "~> 1.3.0"
gem "responders", "~> 0.6.4"
gem "high_voltage", "~> 1.0.1"
#log exception
gem "airbrake"
gem "grit", :path => "vendor/plugins/grit-2.4.1"
gem "cells", "~> 3.8.0"

gem "haml-rails", "~> 0.3.4"
gem "simple_form", :git => 'git://github.com/plataformatec/simple_form.git'
gem "nested_form", :git => 'git://github.com/ryanb/nested_form.git'
gem "kaminari", "~> 0.12.4"
#gem "client_side_validations", "~> 3.1.3"
gem "show_for", "~> 0.2.4"
gem "best_in_place", "~> 1.0.4"
# ckeditor
gem "mini_magick"
gem "ckeditor", :git => "git://github.com/galetahub/ckeditor.git"

gem "attribute_enums", "~> 0.1.7"
gem "carrierwave", "~> 0.5.8"
gem "ancestry", "~> 1.2.4"
gem "by_star", "~> 1.0.1"
##.to_url
gem "stringex", "~> 1.3.0"
gem "friendly_id", "~> 4.0.0.beta14"
#deleted_at
gem "paranoia", "~> 1.1.0"
gem "activevalidators", "~> 1.8.0"
gem "ransack", '~> 0.5.8'
gem "squeel", '~> 0.9.3'
gem "gravtastic", '~> 3.2.3'
gem "basic_model", '~> 0.3.2'
gem 'acts-as-taggable-on', '~>2.2.1'
#sphinx
gem 'thinking-sphinx', '~> 2.0.10'
gem "backup", "~> 3.0.19"
#message
gem 'acts-as-messageable', "~> 0.4.4"

group :development do
  gem 'sqlite3', "~> 1.3.4"
  gem "capistrano", "~> 2.9.0", :require => false
  gem "annotate", "~> 2.4.1.beta1", :require => false
  gem "rails-erd", "~> 0.4.5"
  gem "thin", "~> 1.3.1", :require => false
  gem "foreman", "~> 0.26.1", :require => false
  gem "pry", "~> 0.9.7.4"
  gem 'pry-rails'
  gem "mail_view", "~> 1.0.2"
  gem "active_reload", "~> 0.6.1"
  #gem "rails-footnotes", ">= 3.7.5.rc4"
  #gem "youdao_fanyi", "~> 0.1.2.2"
  #gem "i18n_attributes", "~> 0.1.6"
  #gem "seed_upgrade", "~> 0.1.2"
end

group :test do
  gem "rspec-rails", "~> 2.8"
  gem "rr", "~> 1.0.4"
  gem "capybara", "~> 1.1.2"
  gem "guard", "~> 0.10.0"
  gem "guard-rspec", "~> 0.6.0"
  gem "guard-spork", "~> 0.5.0"
  gem "machinist", ">= 2.0.0.beta2"
  gem "database_cleaner", "~> 0.7.0"
  gem "ffaker", "~> 1.10.1"
  gem "timecop", "~> 0.3.5"
  gem "valid_attribute", "~> 1.2.0"
end

gemfile_local = File.expand_path('../Gemfile.local', __FILE__)
eval(File.read(gemfile_local)) if File.exists?(gemfile_local)

