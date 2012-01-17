class CategoriesController < ApplicationController

  respond_to :json, :only => [:index_children]

  main_nav_highlight :categories, :only => [:index]

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path, :only => [:index]
  add_breadcrumb proc{|c| c.t("shared.topbar.categories")}, :categories_path, :only => [:index]


  def index
    @categories_list = Category.list
  end

  def index_children
    @categories = Category.find(params[:parent_category_id]).children
    respond_with @categories
  end
  
end
