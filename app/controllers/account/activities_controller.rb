class Account::ActivitiesController < Account::BaseController

  add_breadcrumb proc{|c| c.t("shared.topbar.main")}, :root_path
  add_breadcrumb proc{|c| c.t("shared.topbar.profile_center")}, :account_root_path
  add_breadcrumb proc{|c| c.t("account.shared.navigation.my_activities")}, "", :only => [:index]
  add_breadcrumb proc{|c| c.t("account.shared.navigation.about_me_activities")}, "", :only => [:about_me]

  def index
    @activities = current_user.activities.page(params[:page])
  end

  def about_me
    @activities = Activity.about_user(current_user).page(params[:page])
    render :index
  end

end
