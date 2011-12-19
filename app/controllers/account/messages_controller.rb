class Account::MessagesController < Account::BaseController

  layout "messages"

  main_nav_highlight :messages
  sec_nav_highlight :new, :only => [:new, :create]
  sec_nav_highlight :received, :only => [:index]
  sec_nav_highlight :sent, :only => [:sent]
  sec_nav_highlight :notifications, :only => [:notifications]

  respond_to :html
  respond_to :js, :only => [:destroy]

  def new
    @message = Message.new
    @message.receiver_username_post = params[:receiver_username]
  end

  def create
    @message = Message.new(params[:message])
    @message.save
    respond_with :account, @message, :location => [:sent, :account, :messages]
  end

  def show
    @message = Message.by_user(current_user).find(params[:id])
    @message.read!
    @new_message = Message.new
  end

  def destroy
    @message = Message.by_user(current_user).find(params[:id])
    @message.destroy
    respond_with :account, @message
  end

  def reply
    @message = current_user.received_messages.member_mailbox.find(params[:id])
    @new_message = @message.reply!(params[:new_message][:content])
    respond_with :account, @new_message, :location => [:account, :messages], :action => "show"
  end

  def index
    @messages = current_user.received_messages.member_mailbox.page(params[:page])
    @can_reply = true
    respond_with :account, @message
  end

  def sent
    @messages = current_user.sent_messages.page(params[:page])
    respond_with :account, @message, :template => "account/messages/index"
  end

  def notifications
    @messages = current_user.received_messages.system_notification.page(params[:page])
    respond_with :account, @message, :template => "account/messages/index"
  end

end

