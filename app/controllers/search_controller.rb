class SearchController < ApplicationController

  def index
    @users = User.search("pancakes").page(params[:page]).per(10)
  end

end
