class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :username
      t.string :email
      t.text :body
      t.string :state
      t.text :result
      t.integer :handler_id
      t.datetime :handle_at

      t.timestamps
    end
  end
end
