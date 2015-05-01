require 'test_helper'

module Rollenspiel
  class RoleGranteeTest < ActiveSupport::TestCase
    test "grants roles" do
      o = TestOrganization.create!
      u = TestUser.create!

      o.role(:leader).grant_to!(u)
      Role.create(name: :member).grant_to!(u)

      assert u.role? :leader
      assert u.role? o.role(:leader)

      assert u.role? :member
      assert_not u.role? o.role(:member)
    end

    test "grants inherited roles" do
      o = TestOrganization.create!
      u = TestUser.create!

      o.role(:leader).grant_to!(u)

      assert u.role? :create
      assert u.role? :read
      assert u.role? :update
      assert u.role? :destroy

      assert u.role? o.role(:create)
      assert u.role? o.role(:read)
      assert u.role? o.role(:update)
      assert u.role? o.role(:destroy)
    end

    test "grants inherited roles across scopes" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o
      u = TestUser.create!

      o.role(:leader).grant_to!(u)

      assert_not u.role? :leader, TestDepartment

      assert u.role? :create, TestDepartment
      assert u.role? :read, TestDepartment
      assert u.role? :update, TestDepartment
      assert u.role? :destroy, TestDepartment

      assert u.role? d.role(:create)
      assert u.role? d.role(:read)
      assert u.role? d.role(:update)
      assert u.role? d.role(:destroy)
    end

    test "grants class roles" do
      u = TestUser.create!

      admin_role = Role.create! name: 'admin'
      department_admin_role = Role.create! name: 'department_admin', provider_type: TestDepartment

      admin_role.grant_to!(u)
      department_admin_role.grant_to!(u)

      assert u.role? admin_role
      assert u.role? department_admin_role

      assert u.role? :admin
      assert u.role? :department_admin
      assert u.role? :department_admin, TestDepartment
      assert_not u.role? :department_admin, TestOrganization
    end

    test "verifies role in scope class" do
      u = TestUser.create!
      department_admin_role = Role.create! name: 'department_admin', provider_type: TestDepartment
      department_admin_role.grant_to!(u)

      assert_not u.role_in? TestOrganization
      assert u.role_in? TestDepartment
    end

    test "verifies role in scope object" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o
      u = TestUser.create!
      d.role(:read).grant_to!(u)

      assert_not u.role_in? TestOrganization
      assert u.role_in? TestDepartment

      assert_not u.role_in? o
      assert u.role_in? d
    end

    test "verifies inherited role in scope object" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o
      u = TestUser.create!

      o.role(:read).inherit!(d.role(:read))
      o.role(:read).grant_to!(u)

      assert u.role_in? TestOrganization
      assert u.role_in? TestDepartment

      assert u.role_in? o
      assert u.role_in? d
    end
  end
end
