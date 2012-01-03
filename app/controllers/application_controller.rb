require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  enable_authorization do |exception|
    if current_user
      redirect_to root_url, :alert => exception.message
    else
      redirect_to new_session_path(:ok_url => request.path), :alert => t(:require_sign_in)
    end
  end
  
  
  protect_from_forgery

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


    #render, controller use
    def render_site_closed
      render 'pages/site_closed', :status => 200, :layout => false
    end
    def render_404
      render 'pages/page_not_found', :status => 404, :layout => false
    end
    def render_500
      render 'pages/interior_server_mistake', :status => 500, :layout => false
    end


    class << self
      def main_nav_highlight(name, *options)
        class_eval do
          before_filter Proc.new{|c| c.instance_variable_set(:@main_nav, name.to_sym)} ,options.extract_options!.slice(:only, :except)
        end
      end

      def sec_nav_highlight(name, *options)
        class_eval do
          before_filter Proc.new{|c| c.instance_variable_set(:@sec_nav, name.to_sym)} ,options.extract_options!.slice(:only, :except)
        end
      end

      def add_breadcrumb(name, href='', *options)
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

