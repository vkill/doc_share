class PostsCell < Cell::Rails

  def latest
    @posts = Post.includes([:user]).order("created_at").limit(10)
    render
  end

  def latest_with_home_page
    @posts = Post.includes([:user]).order("created_at").limit(5)
    render
  end

end
