require 'test_helper'

module Rollenspiel
  class RoleGranteeTest < ActiveSupport::TestCase
    test "grants roles" do
      o = TestOrganization.create!
      u = TestUser.create!

      o.role(:leader).grant!(u)
      Role.new(name: :member).grant!(u)

      assert u.role? :leader
      assert u.role? :leader, o

      assert u.role? :member
      assert_not u.role? o.role(:member)
    end

    test "grants class roles" do
      u = TestUser.create!

      Role.new(name: :admin).grant!(u)
      Role.new(name: :department_admin, provider_type: TestDepartment).grant!(u)

      assert u.role? :admin
      assert_not u.role? :admin, TestDepartment
      assert_not u.role? :admin, TestOrganization

      assert u.role? :department_admin
      assert u.role? :department_admin, TestDepartment
      assert_not u.role? :department_admin, TestOrganization
    end

    test "verifies role in scope class" do
      u = TestUser.create!
      Role.new(name: :department_admin, provider_type: TestDepartment).grant!(u)

      assert u.role_in? TestDepartment
      assert_not u.role_in? TestOrganization
    end

    test "verifies role in scope object" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o
      u = TestUser.create!
      d.role(:read).grant!(u)

      assert_not u.role_in? TestOrganization
      assert u.role_in? TestDepartment

      assert_not u.role_in? o
      assert u.role_in? d
    end
  end
end
