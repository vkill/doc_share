class AddCountColumnsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :repositories_count, :integer, :default => 0
  end
end
