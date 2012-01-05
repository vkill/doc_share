class PostsController < ApplicationController

  layout 'blog'

  def index
    @posts = Post.order("is_top DESC").order("created_at").page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order("created_at").readonly
    @comment = @comments.build
  end

end
