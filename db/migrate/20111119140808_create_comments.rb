class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, :polymorphic => {}
      t.references :user
      t.text :content

      t.timestamps
    end
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end
end

