class AddCountColumnsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :repositories_count, :integer
  end
end
