require 'machinist/active_record'
include Rake::DSL
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

Role.blueprint do
  name        { "name_#{sn}" }
  code        { "code_#{sn}" }
  describtion { Faker::LoremCN.word }
end

Category.blueprint do
  name        { "name_#{sn}" }
  code        { "code_#{sn}" }
end

Comment.blueprint do
  user            { User.make! }
  commentable     { Repository.make! }
  content         { Faker::Lorem.words }
end

TargetFollower.blueprint do
  # Attributes here
end

Repository.blueprint do
  user        { User.make! }
  category    { Category.make! }
  name        { "repo_#{sn}" }
  describtion { Faker::Lorem.paragraph }
  visibility  {  }
end

Issue.blueprint do
  user        { User.make! }
  repository  { Repository.make! }
  title       { Faker::Lorem.sentence }
  content     { Faker::Lorem.words }
end

Message.blueprint do
  sender { User.make! }
  receiver { User.make! }
  content     { Faker::Lorem.paragraph }
  is_readed   { false }
end

SettingUserNotification.blueprint do
  user  { User.make! }
end

RepoFile.blueprint do
  repository  { Repository.make! }
  file        { File.open(Rails.root.join("config.ru").to_s) }
end

