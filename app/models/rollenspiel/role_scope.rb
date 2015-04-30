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

      scope :by_role_owner, ->(role_owner, role_name=nil) {
        ownerships = Rollenspiel::RoleOwnership.where(owner: role_owner)

        roles = Rollenspiel::Role.where({scope_type: name, id: ownerships.select(:role_id)})

        if role_name
          inheritances = RoleInheritance.where(inherited_role: Rollenspiel::Role.where(name: role_name))
          roles = roles.where(
            Rollenspiel::Role.arel_table[:name].eq(role_name)
              .or(Rollenspiel::Role.arel_table[:id].in(Arel::Nodes::SqlLiteral.new(inheritances.select(:role_id).to_sql)))
          )
        end
        where(id: roles.select(:scope_id))
      }

      has_many :roles, as: :scope,
                       inverse_of: :scope,
                       dependent: :destroy,
                       class_name: 'Rollenspiel::Role'
      after_create :create_roles_structure

      # @param [#to_s] role_name
      # @return [Rollenspiel::Role] role
      def role role_name
        roles.find_by_name(role_name)
      end

      # @param [#to_s] role_name
      # @return [Array<Rollenspiel::RoleOwner>] role_owners
      def owners_of_role role_name
        owners_by_roles roles.where(name: role_name)
      end

      # @param [#to_s] role_name
      # @return [Array<Rollenspiel::RoleOwner>] role_owners
      def indirect_owners_of_role role_name
        inheritances = RoleInheritance.where(inherited_role: roles.where(name: role_name))
        owners_by_roles inheritances.select(:role_id)
      end

      def owners_of_any_role
        owners_by_roles roles
      end

      private

        def owners_by_roles roles
          ownerships = RoleOwnership.where(role: roles)
          RoleOwner.registered_owners.map do |owner_model|
            owner_model.constantize.by_ownerships(ownerships)
          end.flatten
        end
    end

    def create_roles_structure
      structure = RoleStructure.new
      self.class.roles_structure.call(structure, self)
      RoleBuilder.new(structure).create(self)
    end
  end
end
