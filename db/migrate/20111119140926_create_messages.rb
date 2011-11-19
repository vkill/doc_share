class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recerver_id
      t.string :category
      t.text :content
      t.boolean :is_readed,   :default => false

      t.timestamps
    end
  end
end

