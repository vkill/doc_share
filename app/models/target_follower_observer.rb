class TargetFollowerObserver < ActiveRecord::Observer

  observe :target_follower

  def after_create(record)
  end

  def after_destroy(record)
  end

end

