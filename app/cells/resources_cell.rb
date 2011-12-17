class ResourcesCell < Cell::Rails

  def per_page_display(args={})
    @default_per_page = args[:default_per_page] || Kaminari.config.default_per_page
    render
  end

end
