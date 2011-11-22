# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111122065535) do

  create_table "categories", :force => true do |t|
    t.string   "ancestry"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repositories_count"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "issues", :force => true do |t|
    t.integer  "user_id"
    t.integer  "repository_id"
    t.string   "title"
    t.text     "content"
    t.string   "state"
    t.integer  "number_with_repo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count",   :default => 0
  end

  add_index "issues", ["repository_id"], :name => "index_issues_on_repository_id"
  add_index "issues", ["user_id"], :name => "index_issues_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "category"
    t.text     "content"
    t.boolean  "is_readed",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repo_files", :force => true do |t|
    t.integer  "repository_id"
    t.string   "repo_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repo_files", ["repository_id"], :name => "index_repo_files_on_repository_id"

  create_table "repositories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "ancestry"
    t.boolean  "deleted",          :default => false
    t.string   "name"
    t.text     "describtion"
    t.string   "visibility"
    t.string   "features"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "watchers_count",   :default => 0
    t.integer  "repo_files_count", :default => 0
    t.integer  "issues_count",     :default => 0
    t.integer  "comments_count",   :default => 0
  end

  add_index "repositories", ["category_id"], :name => "index_repositories_on_category_id"
  add_index "repositories", ["user_id"], :name => "index_repositories_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "describtion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "setting_user_notifications", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "user_followed", :default => true
    t.boolean  "code_watched",  :default => true
    t.boolean  "code_forked",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "setting_user_notifications", ["user_id"], :name => "index_setting_user_notifications_on_user_id"

  create_table "target_followers", :force => true do |t|
    t.integer  "follower_id"
    t.string   "follower_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "target_followers", ["follower_id"], :name => "index_target_followers_on_follower_id"
  add_index "target_followers", ["target_id"], :name => "index_target_followers_on_target_id"

  create_table "users", :force => true do |t|
    t.string   "username",                                           :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.integer  "failed_logins_count",             :default => 0
    t.datetime "lock_expires_at"
    t.boolean  "is_super_admin",                  :default => false
    t.string   "name"
    t.string   "gender"
    t.string   "site"
    t.string   "company"
    t.string   "location"
    t.string   "state"
    t.integer  "repositories_count",              :default => 0
    t.integer  "issues_count",                    :default => 0
    t.integer  "comments_count",                  :default => 0
    t.integer  "sent_messages_count",             :default => 0
    t.integer  "received_messages_count",         :default => 0
    t.integer  "followers_count",                 :default => 0
    t.integer  "watching_repositories_count",     :default => 0
    t.integer  "following_users_count",           :default => 0
  end

  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end
