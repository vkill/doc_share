require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  username              { "user_#{sn}" }
  email                 { Faker::Internet.email(object.username) }
  password              { "123456" }
  password_confirmation { object.password }
  is_super_admin        { false }
  name                  { Faker::NameCN.name }
  site                  { Faker::Internet.http_url }
  company               { Faker::LoremCN.word }
  location              { Faker::Address.city }
end

User.blueprint(:admin) do
  is_super_admin { true }
end

Role.blueprint do
  name        { "name_#{sn}" }
  code        { "code_#{sn}" }
  describtion { Faker::LoremCN.paragraph }
end

Category.blueprint do
  name        { "name_#{sn}" }
  code        { "code_#{sn}" }
end

Comment.blueprint do
  user            { User.make! }
  commentable     { Repository.make! }
  content         { Faker::Lorem.paragraph }
end

TargetFollower.blueprint do
  follower  { User.make! }
  target    { Repository.make! }
end

Repository.blueprint do
  user        { User.make! }
  category    { Category.make! }
  name        { "repo_#{sn}" }
  describtion { Faker::Lorem.paragraph }
end

Issue.blueprint do
  user        { User.make! }
  repository  { Repository.make! }
  title       { "title_#{sn}" }
  content     { Faker::Lorem.paragraph }
end

Message.blueprint do
  sender { User.make! }
  receiver { User.make! }
  subject     { "subject_#{sn}" }
  content     { Faker::Lorem.paragraph }
end

SettingUserNotification.blueprint do
  user  { User.make! }
end

RepoFile.blueprint do
  repository  { Repository.make! }
  repo_file   { File.open(Rails.root.join("config.ru").to_s) }
end


Activity.blueprint do
  user        { User.make! }
  user_name   { object.user.username }
  action      { 'created_repository' }
  target      { Repository.make! }
end
Activity.blueprint(:created_repository) do
end
Activity.blueprint(:destroyed_repository) do
  action      { 'destroyed_repository' }
  target      { Repository.make! }
end
Activity.blueprint(:followed_user) do
  action      { 'followed_user' }
  target      { User.make! }
end
Activity.blueprint(:unfollowed_user) do
  action      { 'unfollowed_user' }
  target      { User.make! }
end
Activity.blueprint(:watched_repository) do
  action      { 'watched_repository' }
  target      { Repository.make! }
end
Activity.blueprint(:unwatched_repository) do
  action      { 'unwatched_repository' }
  target      { Repository.make! }
end
Activity.blueprint(:forked_repository) do
  action      { 'forked_repository' }
  target      { Repository.make! }
end

