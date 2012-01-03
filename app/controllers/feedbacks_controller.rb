class FeedbacksController < ApplicationController

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.footer.feedbacks")}, :feedbacks_path
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]

  def index
    @feedbacks = Feedback.page(params[:page]).order("updated_at DESC")
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.save
    respond_with @feedback
  end
end
