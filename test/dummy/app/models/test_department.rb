class TestDepartment < ActiveRecord::Base
  belongs_to :test_organization

  include ::Rollenspiel::RoleProvider
  define_roles do |builder, record|
    builder.role record.test_organization.role(:leader), inherits: [:read, :create, :update, :destroy]
    builder.role record.test_organization.role(:member), inherits: [:read]
  end
end
