module Rollenspiel
  class RoleGrant < ActiveRecord::Base
    belongs_to :role
    belongs_to :grantee, polymorphic: true

    has_many :inherited_roles, through: :role

    validates_presence_of :role, :grantee
    validates_uniqueness_of :role_id, scope: [:grantee_id, :grantee_type]
    validates_inclusion_of :grantee_type, in: RoleGrantee.registered_grantees
  end
end
