class Account::MainController < Account::BaseController

  main_nav_highlight :dashboard

  def index
    @new_activities = Activity.limit 30

    @your_repositories = current_user.repositories
    @watching_repositories = current_user.watching_repositories
  end

end

