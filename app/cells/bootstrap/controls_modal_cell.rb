class Bootstrap::ControlsModalCell < Cell::Rails

  def sign_in
    @user = User.new
    render
  end

end
