class PostsController < ApplicationController

  main_nav_highlight :blog
  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.blog")}, :posts_path
  add_breadcrumb proc{|c| c.t(:read_post)}, "", :only => [:show]

  def index
    @posts = Post.order("is_top DESC").order("created_at").page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order("created_at").readonly
    @comment = @comments.build
  end

end
