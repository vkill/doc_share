class Account::MainController < Account::BaseController

  main_nav_highlight :dashboard, :only => [:dashboard]
  main_nav_highlight :notifications_center, :only => [:notifications_center]

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.profile_center")}, :account_root_path
  add_breadcrumb proc{|c| c.t("account.shared.navigation.dashboard")}, "", :only => [:dashboard]
  add_breadcrumb proc{|c| c.t("account.shared.navigation.notifications_center")}, "", :only => [:notifications_center]

  def dashboard
    @new_activities = Activity.limit 20

    @repositories = current_user.repositories
    @watching_repositories = current_user.watching_repositories
  end

  def notifications_center
  end

end

