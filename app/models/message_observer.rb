class MessageObserver < ActiveRecord::Observer

  observe :message

  def after_create(record)
    #count
    case record.category.to_sym
    when :system_notification
      record.received_messageable_type.constantize.increment_counter(:unread_system_notifications_count,
                                                                      record.received_messageable_id)
    when :member_mailbox
      record.received_messageable_type.constantize.increment_counter(:unread_member_mailboxs_count,
                                                                      record.received_messageable_id)
    end
  end

  def after_update(record)
    #count
    if record.open?
      case record.category.to_sym
      when :system_notification
        record.received_messageable_type.constantize.decrement_counter(:unread_system_notifications_count,
                                                                        record.received_messageable_id)
      when :member_mailbox
        record.received_messageable_type.constantize.decrement_counter(:unread_member_mailboxs_count,
                                                                        record.received_messageable_id)
      end
    end
  end

end

