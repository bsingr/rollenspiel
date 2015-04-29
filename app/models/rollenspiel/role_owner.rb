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
        conditions = {}
        if role_or_name.respond_to?(:id)
          conditions[:id] = role_or_name.id
        elsif scope_class
          conditions[:name] = role_or_name
          conditions[:scope_type] = scope_class.to_s
        else
          conditions[:name] = role_or_name
        end
        inherited_roles.where(conditions).exists? ||
          roles.where(conditions).exists?
      end
    end
  end
end
