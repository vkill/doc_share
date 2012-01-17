class CategoriesController < ApplicationController

  respond_to :json, :only => [:index_children]

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path

  def index
    @categories_list = Category.list
  end

  def index_children
    @categories = Category.find(params[:parent_category_id]).children
    respond_with @categories
  end
  
end
