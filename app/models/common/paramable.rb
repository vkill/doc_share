module Paramable
  extend ActiveSupport::Concern

  module InstanceMethods
    def to_param
      # human_name = case self.class.name.downcase.to_sym
      #   when :user        then username
      #   when :repository  then name
      # end
      # "%s-%s" % [id, human_name.parameterize]
    end
  end


end

