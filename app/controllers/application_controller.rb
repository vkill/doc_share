require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery


  def set_current_user(resource_name=nil, attribute_name="user_id")
    return unless (current_user rescue nil)
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

end

