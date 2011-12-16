class Admin::ResourcesBaseController < Admin::BaseController

  before_filter :build_collection, :only => [:index]
  before_filter :find_or_build_resource, :except => [:index]

  helper_method :resource_class, :collection_name, :resource_name, :collection, :resource

  def index
  end

  def new
  end

  def create
    self.send("#{_resource_name()}").save()
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def show
  end

  def edit
  end

  def update
    self.send("#{_resource_name()}").update_attributes(params[_resource_name()])
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def delete
  end

  def destroy
    self.send("#{_resource_name()}").destroy()
    respond_with :admin, self.send("#{_resource_name()}")
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
      self.class.send :attr_accessor, "#{_collection_name()}"
      @q = _resource_class.search(params[:q])
      self.send "#{_collection_name()}=", @q.result().page(params[:page])
    end

    def find_or_build_resource
      self.class.send :attr_accessor, "#{_resource_name()}"
      self.send "#{_resource_name()}=",
          (params[:id] ? _resource_class.find(params[:id]) : _resource_class.new(params[_resource_name()]))
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
      self.send "#{_collection_name()}"
    end
    def resource
      self.send "#{_resource_name()}"
    end

end
