class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.references :user
      t.references :repository
      t.string :title
      t.text :content
      t.string :state
      t.integer :number_with_repo

      t.timestamps
    end
    add_index :issues, :user_id
    add_index :issues, :repository_id
  end
end

