class PostsCell < Cell::Rails

  def latest
    @posts = Post.includes([:user]).order("created_at").limit(10)
    render
  end

end
