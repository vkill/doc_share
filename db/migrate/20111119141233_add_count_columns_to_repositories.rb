class AddCountColumnsToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :watchers_count, :integer, :default => 0
    add_column :repositories, :issues_count, :integer, :default => 0
    add_column :repositories, :comments_count, :integer, :default => 0
  end
end

