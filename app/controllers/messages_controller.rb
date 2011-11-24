class MessagesController < ApplicationController

  before_filter :require_login

  inherit_resources
  respond_to :html, :json
  actions :index, :new, :create

  def index
    @messages = current_user.received_messages.member_mailbox
  end

  def sent
    @messages = current_user.sent_messages
  end

  def notifications
    @messages = current_user.received_messages.system_notification
  end

end

