module Rollenspiel
  class Role < ActiveRecord::Base
    belongs_to :scope, polymorphic: true

    has_many :role_inheritances, dependent: :destroy,
                                 inverse_of: :role
    has_many :inherited_roles, through: :role_inheritances

    has_many :inherited_in_role_inheritances, inverse_of: :role,
                                              class_name: 'RoleInheritance',
                                              foreign_key: :inherited_role_id,
                                              dependent: :destroy
    has_many :inherited_to_roles, through: :inherited_in_role_inheritances,
                                  source: :inherited_role

    has_many :role_ownerships, inverse_of: :role
    has_many :owners,
             through: :role_ownerships

    validates_presence_of :name
    validates_uniqueness_of :name, scope: [:scope_id, :scope_type]
    validates_inclusion_of :scope_type, in: RoleScope.registered_scopes,
                                        allow_nil: true

    # @param [#to_id, #to_s] role_or_name
    # @return [TrueClass, FalseClass] true if the given role is inherited
    def inherited? role_or_name
      if role_or_name.respond_to?(:id)
        inherited_roles.where(id: role_or_name.id).exists?
      else
        inherited_roles.where(name: role_or_name).exists?
      end
    end

    # Builds role ownership for the given owner
    # @param [Rollenspiel::RoleOwner] role_owner becomes owner of this role
    # @return [Rollenspiel::RoleOwnership] role_ownership
    def grant_to role_owner
      role_ownerships.build owner: role_owner
    end

    # Creates a role ownership for the given owner
    # @param [Rollenspiel::RoleOwner] role_owner
    def grant_to! role_owner
      grant_to(role_owner).save!
    end

    # Builds inheritance for the given role
    # @param [Rollenspiel::Role] role
    # @return [Rollenspiel::RoleInheritance] role_inheritance
    def inherit role
      role_inheritances.build inherited_role: role
    end
  end
end
