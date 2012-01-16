class CategoriesCell < Cell::Rails

  def index_parents
    @categories = Category.parents
    render
  end

end
