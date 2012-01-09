module Account::MessagesHelper

  def message_sender_link(message)
    raw link_to(message.sender_username, user_page_path(message.sender_username))
  end

  def message_receiver_link(message)
    raw link_to(message.receiver_username, user_page_path(message.receiver_username))
  end

end
