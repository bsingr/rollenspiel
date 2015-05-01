require "rollenspiel/engine"

module Rollenspiel
  extend ActiveSupport::Concern

  class_methods do
    def role_grantee
      send(:include, Rollenspiel::RoleGrantee)
    end

    def provides_roles_on_instance &block
      unless block_given?
        raise ArgumentError, 'provides_roles_on_instance expects a block with role definitions'
      end
      self.send(:include, Rollenspiel::RoleProvider)
      self.instance_roles_structure = block
    end

    def provides_roles_on_class &block
      unless block_given?
        raise ArgumentError, 'provides_roles_on_class expects a block with role definitions'
      end
      self.send(:include, Rollenspiel::RoleProvider)
      self.class_roles_structure = block
      self.create_roles_structure
    end
  end
end

ActiveRecord::Base.send(:include, Rollenspiel)

