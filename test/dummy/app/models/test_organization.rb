class TestOrganization < ActiveRecord::Base
  provides_roles do |p, record|
    p.role :supervision
  end

  provides_instance_roles do |p, record|
    p.role :leader, inherits: [:read, :create, :update, :destroy]
    p.role :member, inherits: [:read]
  end
end
