class CommentsController < ApplicationController

  before_filter :find_commentable
  before_filter :require_login, :except => [:new]
  before_filter :set_current_user, :only => [:create]

  def index
    @comments = @commentable.comments.page(params[:page])
  end

  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.save
    respond_with @comment, :location => location_url
  end

  private
    def find_commentable
      @commentable = 
        if params[:post_id]
          Post.find(params[:post_id])
        else
          raise "don't found commentable"
        end
    end

    def location_url
      params[:comment][:location_url] || [@commentable]
    end

end
