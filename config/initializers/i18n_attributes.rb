
if Rails.env.development?
  I18nAttributes.configure do |config|
    #more > I18n.available_locales
    config.locales = [:"zh-CN"]
  end
end

