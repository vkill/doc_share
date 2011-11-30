class CreateTargetFollowers < ActiveRecord::Migration
  def change
    create_table :target_followers do |t|
      t.references :follower, :polymorphic => {}
      t.references :target,   :polymorphic => {}

      t.timestamps
    end
    add_index :target_followers, :follower_id
    add_index :target_followers, :target_id
  end
end

