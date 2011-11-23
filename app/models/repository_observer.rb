class RepositoryObserver < ActiveRecord::Observer

  observe :repository
  attr_accessor :record, :action

  def after_create(record)
    self.record = record
    self.action = record.root == record ? :created_repository : :forked_repository
    log
  end

  def after_destroy(record)
    self.record = record
    self.action = :destroyed_repository
    log
  end

  private
    def log
      Activity.log!(
        {:user => record.user, :activity_target => record, :action => action}
      )
    end

end

