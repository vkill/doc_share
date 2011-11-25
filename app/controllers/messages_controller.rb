class MessagesController < ApplicationController

  before_filter :require_login
  layout 'messages'

  def new
    @message = Message.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @message = Message.new(params[:message])
    respond_to do |format|
      if @message.save
        format.html { redirect_to([:sent, :messages], :notice => 'message is created!') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def show
    @message = Message.find(params[:id])
    @message.read!
    @new_message = Message.new
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.sender == current_user or @message.receiver == current_user
        @message.destroy
        @status = :succeed
        format.html { redirect_to([:messages]) }
        format.js
      else
        @status = :failed
        format.html { redirect_to([:messages]) }
        format.js
      end
    end
  end

  def reply
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.reply!(params[:new_message][:content])
        format.html { redirect_to([:sent, :messages], :notice => 'is replied!') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def index
    @messages = current_user.received_messages.member_mailbox.page(params[:page])
  end

  def sent
    @messages = current_user.sent_messages.page(params[:page])
    render :index
  end

  def notifications
    @messages = current_user.received_messages.system_notification.page(params[:page])
    render :index
  end

end

