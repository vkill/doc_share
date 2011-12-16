class Admin::ResourcesBaseController < Admin::BaseController

  before_filter :build_collection, :only => [:index]
  before_filter :find_or_build_resource, :except => [:index]

  helper_method :resource_class, :collection_name, :resource_name, :collection, :resource

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

  def delete
  end

  private
    def _collection_name
      controller_name.pluralize
    end
    def _resource_name
      controller_name.singularize
    end

    def _resource_class
      controller_name.classify.constantize
    end
  
    def build_collection
      @q = _resource_class.search(params[:q])
      self.instance_variable_set :"@#{_collection_name().to_s}", @q.result().page(params[:page])
    end

    def find_or_build_resource
      self.instance_variable_set :"@#{_resource_name().to_s}",
          (params[:id] ? _resource_class.find(params[:id]) : _resource_class.new(params[_resource_name().to_s]))
    end

    #helpers
    def resource_class
      _resource_class()
    end
    def collection_name
      _collection_name().to_sym
    end
    def resource_name
      _resource_name().to_sym
    end
    def collection
      self.instance_variable_get :"@#{_collection_name().to_s}"
    end
    def resource
      self.instance_variable_get :"@#{_resource_name().to_s}"
    end

end
