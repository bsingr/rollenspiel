module Rollenspiel
  class RoleOwnership < ActiveRecord::Base
    belongs_to :role
    belongs_to :owner, polymorphic: true

    has_many :inherited_roles, through: :role

    validates_presence_of :role, :owner
    validates_uniqueness_of :role_id, scope: [:owner_id, :owner_type]
    validates_inclusion_of :owner_type, in: RoleOwner.registered_owners
  end
end
