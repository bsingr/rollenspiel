module Rollenspiel
  class RoleInheritance < ActiveRecord::Base
    belongs_to :role
    belongs_to :inherited_role, class_name: 'Role'

    validates_presence_of :role, :inherited_role
    validates_uniqueness_of :role_id, scope: [:inherited_role_id]
  end
end
