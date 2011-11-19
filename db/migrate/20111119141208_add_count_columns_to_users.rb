class AddCountColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :repositories_count, :integer, :default => 0
    add_column :users, :issues_count, :integer, :default => 0
    add_column :users, :comments_count, :integer, :default => 0
    add_column :users, :messages_count, :integer, :default => 0
    add_column :users, :followers_count, :integer, :default => 0
    add_column :users, :watching_repositories_count, :integer, :default => 0
    add_column :users, :following_users_count, :integer, :default => 0
  end
end

