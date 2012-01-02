class UserObserver < ActiveRecord::Observer

  observe :user

  def before_create(record)
    #build setting_user_notification
    record.build_setting_user_notification
  end


end
