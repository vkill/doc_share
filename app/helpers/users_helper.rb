module UsersHelper

  def user_link(user)
    raw (link_to user.username, user_page_path(user.username))
  end

  def user_reverse_follow_link(user)
    unless me?(user)
      raw link_to (current_user.following_user?(user) ? t("users.helper.unfollow") : t("users.helper.follow")),
                  user_reverse_follow_path(user.username),
                  :method => :put,
                  :remote => true,
                  :data => { "user_reverse_follow_#{user.id}" => true,
                              :buttons => true,
                              :loading_text => t(:requesting),
                              :timeout_text => t(:request_timeout),
                              :server_error_text => t(:request_server_error),
                              :alerts_containers_div => "alerts",
                              :follow_complete_text => t("users.helper.unfollow"),
                              :unfollow_complete_text => t("users.helper.follow")},
                  :class => "btn small primary"
    end
  end

  def user_gravatar_link_by_follow(user)
    raw link_to (image_tag user.gravatar_url(:size => 24)), user_page_path(user)
  end

end
