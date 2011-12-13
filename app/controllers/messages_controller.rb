class MessagesController < ApplicationController

  before_filter :require_login

  main_nav_highlight :messages
  sec_nav_highlight :new, :only => [:new, :create]
  sec_nav_highlight :received, :only => [:index]
  sec_nav_highlight :sent, :only => [:sent]
  sec_nav_highlight :notifications, :only => [:notifications]

  respond_to :html
  respond_to :js, :only => [:destroy]

  def new
    @message = Message.new
    @message.receiver = User.find(params[:receiver]) if params[:receiver]
  end

  def create
    @message = Message.new(params[:message])
    @message.save
    if params[:message][:receiver_id].blank?
      @message.errors.add(:receiver_id, :blank)
    else
      @message.errors.add(:receiver_id, :existence) if User.find_by_username(params[:message][:receiver_id]).blank?
    end
    respond_with @message, :location => [:sent, :messages]
  end

  def show
    @message = Message.by_user(current_user).find(params[:id])
    @message.read!
    @new_message = Message.new
  end

  def destroy
    @message = Message.by_user(current_user).find(params[:id])
    @message.destroy
    respond_with @message
  end

  def reply
    @message = current_user.received_messages.member_mailbox.find(params[:id])
    @new_message = @message.reply!(params[:new_message][:content])
    respond_with @new_message, :location => [:messages], :action => "show"
  end

  def index
    @messages = current_user.received_messages.member_mailbox.page(params[:page])
    @can_reply = true
    respond_with @messages
  end

  def sent
    @messages = current_user.sent_messages.page(params[:page])
    respond_with @messages, :template => "messages/index"
  end

  def notifications
    @messages = current_user.received_messages.system_notification.page(params[:page])
    respond_with @messages, :template => "messages/index"
  end
end

