class TestDepartment < ActiveRecord::Base
  belongs_to :test_organization

  provides_roles_on_instance do |p, record|
    p.role record.test_organization.role(:leader), inherits: [:read, :create, :update, :destroy]
    p.role record.test_organization.role(:member), inherits: [:read]
  end
end
