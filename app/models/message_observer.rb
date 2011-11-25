class MessageObserver < ActiveRecord::Observer

  observe :message

  def after_create(record)
    #count
    case record.category.to_sym
    when :system_notification
      User.increment_counter(:unread_system_notifications_count, record.receiver_id)
    when :member_mailbox
      User.increment_counter(:unread_member_mailboxs_count, record.receiver_id)
    end
  end

  def after_update(record)
    #count
    if record.is_readed?
      case record.category.to_sym
      when :system_notification
        User.decrement_counter(:unread_system_notifications_count, record.receiver_id)
      when :member_mailbox
        User.decrement_counter(:unread_member_mailboxs_count, record.receiver_id)
      end
    end
  end

end

