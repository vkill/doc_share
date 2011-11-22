class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :action
      t.references :target, :polymorphic => {}

      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :target_id
  end
end

