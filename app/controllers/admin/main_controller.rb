class Admin::MainController < Admin::BaseController

	add_breadcrumb :dashboard, :admin_dashboard_path, :only => [:dashboard]

	def dashboard
	end
end
