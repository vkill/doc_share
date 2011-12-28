
class ResqueSchedulerTsIndexWork
  @queue = :resque_scheduler

  def self.perform
    system( %Q` rake ts:index RAILS_ENV="#{Rails.env}" `)
  end
end