class TestOrganization < ActiveRecord::Base
  include ::Rollenspiel::RoleScope
  define_roles do |builder, record|
    builder.role :leader, inherits: [:read, :create, :update, :destroy]
    builder.role :member, inherits: [:read]
  end
end