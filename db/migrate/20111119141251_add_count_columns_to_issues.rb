class AddCountColumnsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :comments_count, :integer, :default => 0
  end
end

