class Admin::MainController < Admin::BaseController

	add_breadcrumb proc{|c| c.t("admin.navigation.dashboard")}, :admin_dashboard_path, :only => [:dashboard]

	def dashboard
	end
end
