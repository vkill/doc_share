class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.references :user
      t.references :category
      t.string :ancestry
      t.string :name
      t.text :describtion
      t.string :visibility
      t.string :features
      t.string :git_repo_path

      t.timestamps
    end
    add_index :repositories, :user_id
    add_index :repositories, :category_id
  end
end

