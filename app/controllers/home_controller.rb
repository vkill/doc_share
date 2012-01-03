class HomeController < ApplicationController

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path

  def index
  end

  def rescue_404
    if Rails.env.development?
      #env["vidibus-routing_error.request_uri"] form vidibus-routing_error
      #env["PATH_INFO"] from rails
      uri = env["PATH_INFO"] || env["vidibus-routing_error.request_uri"]
      raise ActionController::RoutingError, %{No route matches "#{ uri }"}
    else
      render_404
    end
  end
end

