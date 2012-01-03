require "application_responder"

class ApplicationController < ActionController::Base
    
  protect_from_forgery

  #responders
  self.responder = ApplicationResponder
  respond_to :html


  def self.rescue_errors
    rescue_from Exception,                            :with => :render_error
    rescue_from RuntimeError,                         :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_404
    # rescue_from ActionController::RoutingError,       :with => :render_404
    rescue_from ActionController::UnknownController,  :with => :render_error
    rescue_from ActionController::UnknownAction,      :with => :render_error
  end
  rescue_errors unless Rails.env.development?
  
  #cancan exception, must be define on the Exception defined 
  enable_authorization do |exception|
    if current_user
      redirect_to root_url, :alert => exception.message
    else
      redirect_to new_session_path(:ok_url => request.path), :alert => t(:require_sign_in)
    end
  end
  
  
  before_filter :set_locale, :check_site_closed
  
  private
    #filter
    def set_current_user(resource_name=nil, attribute_name="user_id")
      return unless current_user.respond_to?(:id)
      resource_name ||= controller_name.singularize
      params[resource_name] ||= {}
      params[resource_name][attribute_name] = current_user.id
    end

    #filter
    def set_locale
      if params[:locale].present? and params[:locale].to_sym.in?([:"zh-CN", :"en"])
         session[:locale] = params[:locale]
      end
      I18n.locale = session[:locale] || I18n.default_locale
    end
    
    #filter
    # Note: admin namespace and signin controller must skip this filter
    def check_site_closed
      render_site_closed() if SiteConfig.q(:site_closed).to_s == "true"
    end

    #filter
    def self.main_nav_highlight(name, *options)
      class_eval do
        before_filter Proc.new{|c| c.instance_variable_set(:@main_nav, name.to_sym)} ,options.extract_options!.slice(:only, :except)
      end
    end

    #filter
    def self.sec_nav_highlight(name, *options)
      class_eval do
        before_filter Proc.new{|c| c.instance_variable_set(:@sec_nav, name.to_sym)} ,options.extract_options!.slice(:only, :except)
      end
    end

    #filter
    def self.add_breadcrumb(name, href='', *options)
      class_eval do
        before_filter Proc.new{|c|
          breadcrumbs = c.instance_variable_get(:@breadcrumbs) || []
          name =
            if name.is_a?(String); name.to_s
            elsif name.is_a?(Symbol); name.to_s
            elsif name.is_a?(Proc); name.call(self)
            elsif name.is_a?(Proc); name.call(self)
            end
          href =
            if href.is_a?(String); href.to_s
            elsif href.is_a?(Symbol); self.send href
            elsif href.is_a?(Proc); href.call(self)
            elsif href.is_a?(Proc); href.call(self)
            end
          breadcrumbs << [name, href]
          c.instance_variable_set(:@breadcrumbs, breadcrumbs)
        } ,options.extract_options!.slice(:only, :except)
      end
    end


    def render_site_closed
      render 'pages/site_closed', :status => 200, :layout => false
    end

    def render_404(exception=nil)
      Rails.logger.error(exception)
      render 'pages/page_not_found', :status => 404, :layout => false
    end
    
    def render_500(exception=nil)
      Rails.logger.error(exception)
      render 'pages/internal_server_error', :status => 500, :layout => false
    end
    
    def render_error(exception)
      Rails.logger.error(exception)
      render_500
      #airbrake
      notify_airbrake(exception)
    end

    def export_to_csv(model_chain, attributes, filename)
      require "csv"
      (filename = filename + ".csv") if File.extname(filename) != ".csv"
      csv_string = ::CSV.generate do |csv|
        csv << attributes.to_a
        model_chain.find_each do |record|
          csv << attributes.map {|attribute| record.send attribute }
        end 
      end 
      send_data csv_string, 
                :type => Mime::CSV,
                :disposition => "attachment; filename=#{filename}" 
    end

    def export_to_json(json_string, filename)
      (filename = filename + ".json") if File.extname(filename) != ".json"
      send_data json_string, 
                :type => Mime::JSON,
                :disposition => "attachment; filename=#{filename}" 
    end
end

