class Admin::MessagesController < Admin::ResourcesBaseController

  add_breadcrumb proc{|c| c.t("admin.shared.topbar.messages")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.shared.topbar.messages")}, :admin_messages_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export_all")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Message.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_message_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]

  private
    def association_chain
      Message.includes([:received_messageable, :sent_messageable])
    end
end
