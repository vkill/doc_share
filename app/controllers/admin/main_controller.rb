class Admin::MainController < Admin::BaseController

	add_breadcrumb proc{|c| c.t("admin.shared.topbar.dashboard")}, :admin_dashboard_path, :only => [:dashboard]

	def dashboard
	end
end
