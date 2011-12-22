module ApplicationHelper

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

  def translate_attribute(klass, attribute_name)
    klass.human_attribute_name(attribute_name)
  end
  alias :ta :translate_attribute

  def time_ago(time)
    t(:time_ago, :time_words => time_ago_in_words(time))
  end

  def nbsp(n=1)
    raw ("&nbsp" * n)
  end
end

