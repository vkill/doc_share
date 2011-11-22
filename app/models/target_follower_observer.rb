class TargetFollowerObserver < ActiveRecord::Observer

  observe :target_follower

  def after_create(record)
    action = case record.target_type.to_s
      when "User" then :watch_repository
      when "Repository" then :follow_user
    end
    log(record, action)
  end

  def after_destroy(record)
    record = record
    action = case record.target_type.to_s
      when "User" then :unwatch_repository
      when "Repository" then :unfollow_user
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

