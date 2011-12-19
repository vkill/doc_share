class AddDeletedAtToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :deleted_at, :datetime
  end
end
