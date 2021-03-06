class AddCountColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :repositories_count, :integer, :default => 0
    add_column :users, :public_repositories_count, :integer, :default => 0
    add_column :users, :private_repositories_count, :integer, :default => 0
    add_column :users, :issues_count, :integer, :default => 0
    add_column :users, :comments_count, :integer, :default => 0
    add_column :users, :sent_messages_count, :integer, :default => 0
    add_column :users, :received_messages_count, :integer, :default => 0
    add_column :users, :followers_count, :integer, :default => 0
    add_column :users, :watching_repositories_count, :integer, :default => 0
    add_column :users, :following_users_count, :integer, :default => 0
    add_column :users, :unread_system_notifications_count, :integer, :default => 0
    add_column :users, :unread_member_mailboxs_count, :integer, :default => 0
  end
end

