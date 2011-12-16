module ApplicationHelper
  def new_user
    User.new
  end

  def owner?(target)
    return false if !target.respond_to?(:user_id) or !current_user.respond_to?(:id)
    target.user_id == current_user.id
  end

  def me?(user)
    return false if !user.respond_to?(:id) or !current_user.respond_to?(:id)
    user.id == current_user.id
  end

  def admin?
    return false if !current_user.respond_to?(:id)
    current_user.has_role?("admin") or current_user.super_admin?
  end
end

