class TestOrganization < ActiveRecord::Base
  provides_roles_on_class do |p, record|
    p.role :supervision
  end

  provides_roles_on_instance do |p, record|
    p.role :leader, inherits: [:read, :create, :update, :destroy]
    p.role :member, inherits: [:read]
  end
end
