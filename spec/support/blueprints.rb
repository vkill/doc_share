require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  # Attributes here
end

Role.blueprint do
  # Attributes here
end

Category.blueprint do
  # Attributes here
end

Comment.blueprint do
  # Attributes here
end

TargetFollower.blueprint do
  # Attributes here
end

Repository.blueprint do
  # Attributes here
end

Issue.blueprint do
  # Attributes here
end

Message.blueprint do
  # Attributes here
end

SettingUserNotification.blueprint do
  # Attributes here
end

RepoFile.blueprint do
  # Attributes here
end
