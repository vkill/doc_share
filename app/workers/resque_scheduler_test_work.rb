
class ResqueSchedulerTestWork
  @queue = :resque_scheduler

  def self.perform
    Rails.logger.info "resque scheduler test, by vkill"
  end
end
