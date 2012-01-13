class CanAccessResque

  def self.matches?(request)
    current_user = User.find_by_id(request.session[:user_id])
    return false if current_user.blank?
    AbilityAdmin.new(current_user).can? :manage, Resque
  end
end