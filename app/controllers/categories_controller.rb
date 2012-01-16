class CategoriesController < ApplicationController

  respond_to :json, :only => [:index_children]

  def index
  end

  def index_children
    @categories = Category.find(params[:parent_category_id]).children
    respond_with @categories
  end

end
