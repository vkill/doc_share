require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  before_filter :set_locale


  private
    def set_current_user(resource_name=nil, attribute_name="user_id")
      return unless current_user.respond_to?(:id)
      resource_name ||= controller_name.singularize
      params[resource_name] ||= {}
      params[resource_name][attribute_name] = current_user.id
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
    end

    def set_locale
      if params[:locale].present? and params[:locale].to_sym.in?([:"zh-CN", :"en"])
         session[:locale] = params[:locale]
      end
      I18n.locale = session[:locale] || I18n.default_locale
    end

end

