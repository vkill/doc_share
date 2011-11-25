class RepositoryObserver < ActiveRecord::Observer

  observe :repository

  def after_create(record)
    #count
    if record.parent
      Repository.increment_counter(:forks_count, record.root.id)
    end
    #log
    action = record.root == record ? :created_repository : :forked_repository
    log(record, action)
  end

  def after_destroy(record)
    #log
    action = :destroyed_repository
    log(record, action)
  end

  private
    def log(record, action)
      Activity.log!(
        {:user => record.user, :activity_target => record, :action => action}
      )
    end

end

