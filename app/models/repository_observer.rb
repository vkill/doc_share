class RepositoryObserver < ActiveRecord::Observer

  observe :repository

  def after_create(record)

    #forks count
    if record.parent
      Repository.increment_counter(:forks_count, record.root.id)
    end

    #count
    User.increment_counter("#{ record.visibility }_repositories_count", record.user.id)

    #log
    action = record.root == record ? :created_repository : :forked_repository
    log(record, action)
  end

  def before_update(record)
    #count
    if record.changed? and record.changed_attributes['visibility']
      User.decrement_counter("#{ record.changed_attributes['visibility'] }_repositories_count", record.user.id)
      User.increment_counter("#{ record.visibility }_repositories_count", record.user.id)
    end
  end

  def after_destroy(record)
    #count
    User.decrement_counter("#{ record.visibility }_repositories_count", record.user.id)

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

