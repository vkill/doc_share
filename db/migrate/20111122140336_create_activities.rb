class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :user_name
      t.string :action
      t.references :activityable, :polymorphic => {}

      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :activityable_id
  end
end

