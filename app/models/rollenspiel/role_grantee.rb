module Rollenspiel
  module RoleGrantee
    extend ActiveSupport::Concern

    def self.registered_grantees
      @registered_grantees ||= []
    end

    included do
      RoleGrantee.registered_grantees << name

      scope :by_role_provider_type, ->(provider_type) {
        joins(:role_grants).where(
          'rollenspiel_role_grants.role_id' => Rollenspiel::Role.by_provider_type(provider_type)
        ).distinct
      }
      scope :by_grants, ->(grants) { where(id: grants.where(grantee_type: name).select(:grantee_id)) }

      has_many :role_grants,
               as: :grantee,
               inverse_of: :grantee,
               dependent: :destroy,
               class_name: 'Rollenspiel::RoleGrant'
      has_many :roles,
               through: :role_grants,
               class_name: 'Rollenspiel::Role'
      has_many :inherited_roles,
               through: :role_grants,
               class_name: 'Rollenspiel::Role'

      # @param [#to_id, #to_s] role_or_name
      # @param [#to_s] role_provider_class
      # @return [TrueClass, FalseClass] true when the role is owned
      def role? role_or_name, role_provider_class=nil
        conditions = role_conditions(role_or_name, role_provider_class)
        inherited_roles.where(conditions).exists? ||
          roles.where(conditions).exists?
      end

      # @param [#to_id, #to_s] role_or_name
      # @param [#to_s] role_provider_class
      # @return [TrueClass, FalseClass] true when the role is granted
      def actual_role? role_or_name, role_provider_class=nil
        conditions = role_conditions(role_or_name, role_provider_class)
        roles.where(conditions).exists?
      end

      # @param [#to_id, #to_s] role_provider_or_class
      # @return [TrueClass, FalseClass] true when a role of a provider is granted
      def role_in? role_provider_or_class
        conditions = {}
        if role_provider_or_class.respond_to?(:id)
          conditions[:provider] = role_provider_or_class
        else
          conditions[:provider_type] = role_provider_or_class
        end
        roles.where(conditions).exists? || inherited_roles.where(conditions).exists?
      end

    private

      def role_conditions role_or_name, role_provider_class=nil
        conditions = {}
        if role_or_name.respond_to?(:id)
          conditions[:id] = role_or_name.id
        elsif role_provider_class
          conditions[:name] = role_or_name
          conditions[:provider_type] = role_provider_class.to_s
        else
          conditions[:name] = role_or_name
        end
        conditions
      end
    end
  end
end
