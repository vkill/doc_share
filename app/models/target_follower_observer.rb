class TargetFollowerObserver < ActiveRecord::Observer

  observe :target_follower
  attr_accessor :record, :action

  def after_create(record)
    self.record = record
    self.action = case record.target_type.to_s
      when "User" then :followed_user
      when "Repository" then :watched_repository
    end
    log
  end

  def after_destroy(record)
    self.record = record
    self.action = case record.target_type.to_s
      when "User" then :unfollowed_user
      when "Repository" then :unwatched_repository
    end
    log
  end

  private
    def log
      Activity.log!(
        {:user => record.follower, :activity_target => record.target, :action => action}
      )
    end

end

