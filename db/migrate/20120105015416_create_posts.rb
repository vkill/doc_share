class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :title
      t.string :permalink
      t.text :content
      t.boolean :is_top
      t.string :category
      
      t.timestamps
    end
    add_index :posts, :user_id
  end
end
