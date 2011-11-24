class HomeController < ApplicationController
  def index
    flash[:info] = 1234
    flash[:error] = 5678
  end

end

