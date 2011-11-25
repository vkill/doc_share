require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery


  def set_current_user(resource_name=nil, attribute_name="user_id")
    return unless (current_user rescue nil)
    resource_name ||= controller_name.singularize
    params[resource_name][attribute_name] = current_user.id
  end

end

