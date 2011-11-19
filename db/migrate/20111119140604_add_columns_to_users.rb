class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_super_admin, :boolean, :default => false
    add_column :users, :name, :string
    add_column :users, :gender, :string
    add_column :users, :site, :string
    add_column :users, :company, :string
    add_column :users, :location, :string
    add_column :users, :state, :string
  end
end

