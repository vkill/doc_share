if Rails.env.development?
  I18nAttributes.configure do |config|
    #more > I18n.available_locales
    config.locales = [:"zh-CN"]
    config.enums_attributes = {
      "gender" => {"male" => "Male", "female" => "Female"},
      "state" => {"pending" => "Pending", "processing" => "Processing", "processed" => "Processed"},
      "category" => {"a" => "A", "b" => "B"}
    }
  end
end

