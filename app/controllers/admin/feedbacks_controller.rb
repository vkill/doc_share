class Admin::FeedbacksController < Admin::ResourcesBaseController

  before_filter :set_current_user, :only => [:update]

  add_breadcrumb proc{|c| c.t("admin.shared.topbar.feedbacks")}, "", :only => [:index]
  
  add_breadcrumb proc{|c| c.t("admin.shared.topbar.feedbacks")}, :admin_feedbacks_path, :except => [:index]
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("export_all")}, "", :only => [:export]

  add_breadcrumb proc{|c| "#{Feedback.model_name.human} ##{c.params[:id]}"}, proc{|c| c.admin_feedback_path},
                  :except => [:index, :new, :create, :export]
  add_breadcrumb proc{|c| c.t("show")}, "", :only => [:show]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]
  add_breadcrumb proc{|c| c.t("delete")}, "", :only => [:delete, :destroy]

  def download_attachment
    send_file @feedback.attachment.file.to_file
  end
end
