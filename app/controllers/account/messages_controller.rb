class Account::MessagesController < Account::BaseController

  respond_to :html
  respond_to :js, :only => [:destroy]

  main_nav_highlight :messages

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.profile_center")}, :account_root_path

  add_breadcrumb proc{|c| c.t("account.shared.navigation.messages")}, :account_messages_path
  
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| [c.t("show"), c.t("reply")].join("&")}, "", :only => [:show, :reply]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]

  add_breadcrumb proc{|c| c.t("account.shared.navigation.sent_messages")}, :sent_account_messages_path,
                          :only => [:sent]
  add_breadcrumb proc{|c| c.t("account.shared.navigation.received_messages")}, :account_messages_path,
                          :only => [:index]
  add_breadcrumb proc{|c| c.t("account.shared.navigation.notifications")}, :notifications_account_messages_path,
                          :only => [:notifications]


  def new
    @message = Message.new
    @message.receiver_username_post = params[:receiver_username]
  end

  def create
    params[:message][:sent_messageable_id] = current_user.id
    params[:message][:sent_messageable_type] = current_user.class.name
    @message = Message.new(params[:message])
    @message.save
    respond_with :account, @message, :location => [:sent, :account, :messages]
  end

  def show
    @message = current_user.messages.find(params[:id])
    @message.mark_as_read
    @new_message = Message.new
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    current_user.delete_message(@message)
    respond_with :account, @message, :location => after_destroy_location_url
  end

  def reply
    @message = current_user.received_messages.member_mailbox.find(params[:id])
    @new_message = @message.reply(:topic => @message.reply_topic, :body => params[:new_message][:body])
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

  private
    def after_destroy_location_url
      if @message.sender_id == current_user.id
        [:sent, :account, :messages]
      elsif @message.receiver_id == current_user.id
        [:account, :messages]
      end
    end
end

