module Rollenspiel
  module RoleProvider
    extend ActiveSupport::Concern

    def self.registered_providers
      @registered_providers ||= []
    end

    class_methods do
      def define_roles &block
        self.roles_structure = block
      end
    end

    included do
      class_attribute :roles_structure

      RoleProvider.registered_providers << name

      scope :by_role_grantee, ->(role_grantee, role_name=nil) {
        grants = Rollenspiel::RoleGrant.where(grantee: role_grantee)

        roles = Rollenspiel::Role.where({provider_type: name, id: grants.select(:role_id)})

        if role_name
          inheritances = RoleInheritance.where(inherited_role: Rollenspiel::Role.where(name: role_name))
          roles = roles.where(
            Rollenspiel::Role.arel_table[:name].eq(role_name)
              .or(Rollenspiel::Role.arel_table[:id].in(Arel::Nodes::SqlLiteral.new(inheritances.select(:role_id).to_sql)))
          )
        end
        where(id: roles.select(:provider_id))
      }

      has_many :roles, as: :provider,
                       inverse_of: :provider,
                       dependent: :destroy,
                       class_name: 'Rollenspiel::Role'
      after_create :create_roles_structure

      # @param [#to_s] role_name
      # @return [Rollenspiel::Role] role
      def role role_name
        roles.find_by_name(role_name)
      end

      # @param [#to_s] role_name
      # @return [Array<Rollenspiel::RoleGrantee>] role_grantees
      def grantees_of_role role_name
        grantees_by_roles roles.where(name: role_name)
      end

      # @param [#to_s] role_name
      # @return [Array<Rollenspiel::RoleGrantee>] role_grantees
      def indirect_grantees_of_role role_name
        inheritances = RoleInheritance.where(inherited_role: roles.where(name: role_name))
        grantees_by_roles inheritances.select(:role_id)
      end

      def grantees_of_any_role
        grantees_by_roles roles
      end

      private

        def grantees_by_roles roles
          grants = RoleGrant.where(role: roles)
          RoleGrantee.registered_grantees.map do |grantee_model|
            grantee_model.constantize.by_grants(grants)
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
