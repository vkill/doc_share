if Rails.env.development? and defined?(YoudaoFanyi)
  YoudaoFanyi.configure do |config|
    config.api_keys = YAML.load_file(Rails.root.join("config/youdao_fanyi_api_keys.yml").to_s)["youdao_fanyi_api_keys"]
#    config.http_proxy = 'http://127.0.0.1:8118'
  end
end

