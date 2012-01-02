class TargetFollowerObserver < ActiveRecord::Observer

  observe :target_follower

  # user follow user or watch repository
  def after_create(record)
    #count
    case record.target_type.to_s
      when "User"
        User.increment_counter(:following_users_count, record.follower_id)
        User.increment_counter(:followers_count, record.target_id)
      when "Repository"
        User.increment_counter(:watching_repositories_count, record.follower_id)
        Repository.increment_counter(:watchers_count, record.target_id)
    end

    #log activity
    action = case record.target_type.to_s
      when "User" then :followed_user
      when "Repository" then :watched_repository
    end
    log(record, action)

  end

  # user unfollow user or unwatch repository
  def after_destroy(record)
    #count
    case record.target_type.to_s
      when "User"
        User.decrement_counter(:following_users_count, record.follower_id)
        User.decrement_counter(:followers_count, record.target_id)
      when "Repository"
        User.decrement_counter(:watching_repositories_count, record.follower_id)
        Repository.decrement_counter(:watchers_count, record.target_id)
    end

    #log activity
    action = case record.target_type.to_s
      when "User" then :unfollowed_user
      when "Repository" then :unwatched_repository
    end
    log(record, action)
    
  end

  private
    def log(record, action)
      Activity.log!(
        {:user => record.follower, :activity_target => record.target, :action => action}
      )
    end

end

