class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :category
      t.string :subject
      t.text :content
      t.string :ancestry
      t.boolean :is_readed,   :default => false

      t.timestamps
    end
  end
end

