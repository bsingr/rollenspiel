require "rollenspiel/engine"

module Rollenspiel
  extend ActiveSupport::Concern

  class_methods do
    def role_grantee
      send(:include, Rollenspiel::RoleGrantee)
    end

    def role_provider
      self.send(:include, Rollenspiel::RoleProvider)
    end

    def implicit_role options
      ImplicitRole.register(options)
    end
  end
end

ActiveRecord::Base.send(:include, Rollenspiel)

