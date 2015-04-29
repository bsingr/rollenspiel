require 'test_helper'

module Rollenspiel
  class RoleOwnerTest < ActiveSupport::TestCase
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
  end
end