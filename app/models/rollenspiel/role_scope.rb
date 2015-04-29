module Rollenspiel
  module RoleScope
    extend ActiveSupport::Concern

    def self.registered_scopes
      @registered_scopes ||= []
    end

    class_methods do
      def define_roles &block
        self.roles_structure = block
      end
    end

    included do
      class_attribute :roles_structure

      RoleScope.registered_scopes << name

      has_many :roles, as: :scope,
                       inverse_of: :scope,
                       dependent: :destroy,
                       class_name: 'Rollenspiel::Role'
      has_many :inherited_roles, through: :roles,
                                 class_name: 'Rollenspiel::Role'

      after_create :create_roles_structure

      # @param [#to_s] role_name
      # @return [Rollenspiel::Role] role
      def role role_name
        roles.find_by_name(role_name)
      end
    end

    def create_roles_structure
      structure = RoleStructure.new
      self.class.roles_structure.call(structure, self)
      RoleBuilder.new(structure).create(self)
    end
  end
end
