class Admin::BaseController < ApplicationController

  layout 'admin'

  before_filter :require_login
  before_filter :set_current_user, :only => [:create, :update]

  before_filter :collection, :only => [:index]
  before_filter :resource, :except => [:index]

  add_breadcrumb proc{|c| c.t("admin.navigation.main")}, :admin_root_path

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def resource_class
      controller_name.classify.constantize
    end

    def collection
      @q = resource_class.search(params[:q])
      self.instance_variable_set :"@#{controller_name.pluralize}", @q.result().page(params[:page])
    end

    def resource
      self.instance_variable_set :"@#{controller_name.singularize}",
          (params[:id] ? resource_class.find(params[:id]) : resource_class.new(params[controller_name.singularize]))
    end

end
