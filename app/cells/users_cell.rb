class UsersCell < Cell::Rails

  def count
    @users_count = User.count
    render
  end

  def activity
    @users = User.activity(20)
    render :view => "users_list.html.haml"
  end

  def recent_join
    @users = User.recent_join(20)
    render :view => "users_list.html.haml"
  end

end
