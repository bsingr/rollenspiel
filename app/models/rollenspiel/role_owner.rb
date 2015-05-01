module Rollenspiel
  module RoleOwner
    extend ActiveSupport::Concern

    def self.registered_owners
      @registered_owners ||= []
    end

    included do
      RoleOwner.registered_owners << name

      scope :by_ownerships, ->(ownerships) { where(id: ownerships.where(owner_type: name).select(:owner_id)) }

      has_many :role_ownerships,
               as: :owner,
               inverse_of: :owner,
               dependent: :destroy,
               class_name: 'Rollenspiel::RoleOwnership'
      has_many :roles,
               through: :role_ownerships,
               class_name: 'Rollenspiel::Role'
      has_many :inherited_roles,
               through: :role_ownerships,
               class_name: 'Rollenspiel::Role'

      # @param [#to_id, #to_s] role_or_name
      # @param [#to_s] scope_class
      # @return [TrueClass, FalseClass] true when the role is owned
      def role? role_or_name, scope_class=nil
        conditions = role_conditions(role_or_name, scope_class)
        inherited_roles.where(conditions).exists? ||
          roles.where(conditions).exists?
      end

      # @param [#to_id, #to_s] role_or_name
      # @param [#to_s] scope_class
      # @return [TrueClass, FalseClass] true when the role is owned
      def actual_role? role_or_name, scope_class=nil
        conditions = role_conditions(role_or_name, scope_class)
        roles.where(conditions).exists?
      end

      # @param [#to_id, #to_s] scope_object_or_class
      # @return [TrueClass, FalseClass] true when the role is owned in the scope
      def role_in? scope_object_or_class
        conditions = {}
        if scope_object_or_class.respond_to?(:id)
          conditions[:scope] = scope_object_or_class
        else
          conditions[:scope_type] = scope_object_or_class
        end
        roles.where(conditions).exists? || inherited_roles.where(conditions).exists?
      end

    private

      def role_conditions role_or_name, scope_class=nil
        conditions = {}
        if role_or_name.respond_to?(:id)
          conditions[:id] = role_or_name.id
        elsif scope_class
          conditions[:name] = role_or_name
          conditions[:scope_type] = scope_class.to_s
        else
          conditions[:name] = role_or_name
        end
        conditions
      end
    end
  end
end
