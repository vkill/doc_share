class CommentsController < ApplicationController

  layout :set_layout

  respond_to :html, :only => [:new, :create, :edit, :update]
  respond_to :json, :only => [:index, :show]

  before_filter :require_login, :except => [:index, :new]
  before_filter :set_current_user, :only => [:create]
  before_filter :find_commentable
  before_filter :find_comment, :except => [:index, :new, :create]

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| "#{Comment.model_name.human}"}, "javascript:void(0)"
  add_breadcrumb proc{|c| c.t("new")}, "", :only => [:new, :create]
  add_breadcrumb proc{|c| c.t("edit")}, "", :only => [:edit, :update]

  def index
    @comments = @commentable.comments.order("created_at").page(params[:page])
  end

  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.save
    respond_with @comment, :location => location_url
  end

  def show
  end

  def edit
  end

  def update
    @comment.update_attributes(params[:comment])
    respond_with @comment, :location => location_url
  end
  
  private
    def set_layout
      if params[:post_id]
        'application'
      else
        raise "don't found commentable"
      end
    end

    def find_commentable
      @commentable = 
        if params[:post_id]
          Post.find(params[:post_id])
        else
          raise "don't found commentable"
        end
    end

    def find_comment
      @comment = @commentable.comments.where(:user_id => current_user.id).find(params[:id])
    end
      
    def location_url
      params[:comment][:location_url] || [@commentable]
    end

end
