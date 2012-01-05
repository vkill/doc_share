class PostsController < ApplicationController

  layout 'blog'

  def index
    @posts = Post.order("is_top").page(params[:page])
  end

  def show
    
  end

end
