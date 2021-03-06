class Admin::ResourcesBaseController < Admin::BaseController

  respond_to :html
  respond_to :json, :only => [:index]
  respond_to :csv, :only => [:index]

  before_filter :set_attr_collection_name, :only => [:index, :export]
  before_filter :set_attr_resource_name, :except => [:index, :export]
  before_filter :find_resource, :except => [:index, :export, :new, :create]

  helper_method :resource_class, :collection_name, :resource_name, :collection, :resource

  def index
    if params[:export_all]
      self.send "#{_collection_name()}=", association_chain.select(params[:column_names].to_a)
    else
      @q = association_chain.ransack(params[:q])
      self.send "#{_collection_name()}=", @q.result().\
                        page(params[:page]).per(params[:per_page] || _resource_class.send(:default_per_page)).\
                        order("updated_at DESC")
    end
    respond_with :admin, self.send("#{_collection_name()}") do |format|
      format.csv { export_to_csv(self.send("#{_collection_name()}"),
                        (params[:column_names] || _resource_class.column_names), _collection_name()) }
      if params[:export_all] or params[:export_current]
        format.json { export_to_json(self.send("#{_collection_name()}").to_json, _collection_name()) }
      end
    end
  end

  def export
    respond_with
  end

  def new
    # @role = Role.new()
    # @role = current_user.roles.new()
    self.send "#{_resource_name()}=", association_chain().new()
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def create
    # @role = Role.new(params[:role])
    # @role = current_user.roles.new(params[:role])
    self.send "#{_resource_name()}=", association_chain().new(params[_resource_name()], :as => :admin)
    self.send("#{_resource_name()}").save
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def show
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def edit
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def update
    self.send("#{_resource_name()}").assign_attributes(params[_resource_name()], :as => :admin)
    self.send("#{_resource_name()}").save()
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def destroy
    self.send("#{_resource_name()}").destroy()
    respond_with :admin, self.send("#{_resource_name()}")
  end

  def delete
    respond_with :admin, self.send("#{_resource_name()}")
  end

  private
    #Role
    def _resource_class
      controller_name.classify.constantize
    end
    #roles
    def _collection_name
      controller_name.pluralize
    end
    #role
    def _resource_name
      controller_name.singularize
    end
    #@roles
    def set_attr_collection_name
      self.class.send :attr_accessor, "#{_collection_name()}"
    end
    #@role
    def set_attr_resource_name
      self.class.send :attr_accessor, "#{_resource_name()}"
    end
    #Role or current_user.roles
    def association_chain
      _resource_class
    end
    #@role = Role.find(1)
    #@role = current_user.roles.find(1) 
    def find_resource
      self.send "#{_resource_name()}=", association_chain().find(params[:id])
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
