class MessageObserver < ActiveRecord::Observer

  observe :message

  def after_create(record)
    case record.category.to_sym
    when :system_notification
      record.receiver.send :increment_unread_system_notifications_count
    when :member_mailbox
      record.receiver.send :increment_unread_member_mailboxs_count
    end
  end

  def after_update(record)
    if record.is_readed?
      case record.category.to_sym
      when :system_notification
        record.receiver.send :decrement_unread_system_notifications_count
      when :member_mailbox
        record.receiver.send :decrement_unread_member_mailboxs_count
      end
    end
  end

end

