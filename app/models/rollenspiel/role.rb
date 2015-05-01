module Rollenspiel
  class Role < ActiveRecord::Base
    scope :by_provider_type, ->(provider_type) { where(provider_type: provider_type) }

    belongs_to :provider, polymorphic: true

    has_many :role_inheritances, dependent: :destroy,
                                 inverse_of: :role
    has_many :inherited_roles, through: :role_inheritances

    has_many :inherited_in_role_inheritances, inverse_of: :role,
                                              class_name: 'RoleInheritance',
                                              foreign_key: :inherited_role_id,
                                              dependent: :destroy
    has_many :inherited_to_roles, through: :inherited_in_role_inheritances,
                                  source: :inherited_role

    has_many :role_grants, inverse_of: :role
    has_many :grantees,
             through: :role_grants

    validates_presence_of :name
    validates_uniqueness_of :name, scope: [:provider_id, :provider_type]
    validates_inclusion_of :provider_type, in: RoleProvider.registered_providers,
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

    # Builds role grant for the given grantee
    # @param [Rollenspiel::RoleGrantee] role_grantee becomes grantee of this role
    # @return [Rollenspiel::RoleGrant] role_grant
    def grant_to role_grantee
      role_grants.build grantee: role_grantee
    end

    # Creates a role grant for the given grantee
    # @param [Rollenspiel::RoleGrantee] role_grantee
    def grant_to! role_grantee
      o = grant_to(role_grantee)
      o.save!
      o
    end

    # Builds inheritance for the given role
    # @param [Rollenspiel::Role] role
    # @return [Rollenspiel::RoleInheritance] role_inheritance
    def inherit role
      raise ArgumentError, "Role(#{inspect})#inherit requires role" unless role
      role_inheritances.find_or_initialize_by inherited_role: role
    end

    # Creates inheritance for the given role
    # @param [Rollenspiel::Role] role
    # @return [Rollenspiel::RoleInheritance] role_inheritance
    def inherit! role
      inherit(role).save!
    end

    def to_s
      "#{self.class}(#{name}, #{provider_type})"
    end
  end
end
