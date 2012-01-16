class UsersCell < Cell::Rails

  def activity
    @users = User.activity(20)
    render :view => "users_list.html.haml"
  end

  def recent_join
    @users = User.recent_join(20)
    render :view => "users_list.html.haml"
  end

end
