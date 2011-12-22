class HomeController < ApplicationController

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path

  def index
  end

end

