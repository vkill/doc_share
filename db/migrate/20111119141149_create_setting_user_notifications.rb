class CreateSettingUserNotifications < ActiveRecord::Migration
  def change
    create_table :setting_user_notifications do |t|
      t.references :user
      t.boolean :user_followed, :default => true
      t.boolean :repository_watched,  :default => true
      t.boolean :repository_forked,   :default => true

      t.timestamps
    end
    add_index :setting_user_notifications, :user_id
  end
end

