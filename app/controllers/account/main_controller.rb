class Account::MainController < Account::BaseController

  main_nav_highlight :dashboard, :only => [:dashboard]
  main_nav_highlight :notifications_center, :only => [:notifications_center]

  def dashboard
    @new_activities = Activity.limit 30

    @your_repositories = current_user.repositories
    @watching_repositories = current_user.watching_repositories
  end

  def notifications_center
  end

end

