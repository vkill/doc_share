class MessageObserver < ActiveRecord::Observer

  observe :message

  def after_create(record)
    #count
    if record.received_messageable_id?
      case record.category.to_sym
      when :system_notification
        record.received_messageable_type.constantize.increment_counter(:unread_system_notifications_count,
                                                                        record.received_messageable_id)
      when :member_mailbox
        record.received_messageable_type.constantize.increment_counter(:unread_member_mailboxs_count,
                                                                        record.received_messageable_id)
      end
    end
  end

  def before_update(record)
    #count
    # if message.mark_as_read or user.delete_message(message)
    if (record.opened_changed? or (!record.open? and record.recipient_delete_changed?)) and record.received_messageable_id?
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

