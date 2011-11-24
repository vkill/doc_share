
2.times do
  Activity.make!
  Activity.make!(:created_repository)
  Activity.make!(:destroyed_repository)
  Activity.make!(:followed_user)
  Activity.make!(:unfollowed_user)
  Activity.make!(:watched_repository)
  Activity.make!(:unwatched_repository)
  Activity.make!(:forked_repository)
end

