require 'test_helper'

module Rollenspiel
  class RoleScopeTest < ActiveSupport::TestCase
    test "creates roles" do
      o = TestOrganization.new

      assert_difference('Rollenspiel::Role.count', 6) do
        o.save!
      end

      assert_not_nil o.role(:leader)
      assert_not_nil o.role(:member)
      assert_not_nil o.role(:create)
      assert_not_nil o.role(:read)
      assert_not_nil o.role(:update)
      assert_not_nil o.role(:destroy)
    end

    test "creates inherited roles" do
      o = TestOrganization.new

      assert_difference('Rollenspiel::RoleInheritance.count', 5) do
        o.save!
      end

      assert o.role(:leader).inherited?(o.role(:create))
      assert o.role(:leader).inherited?(o.role(:read))
      assert o.role(:leader).inherited?(o.role(:update))
      assert o.role(:leader).inherited?(o.role(:destroy))

      assert_not o.role(:member).inherited?(o.role(:create))
      assert o.role(:member).inherited?(o.role(:read))
      assert_not o.role(:member).inherited?(o.role(:update))
      assert_not o.role(:member).inherited?(o.role(:destroy))
    end

    test "creates inherited roles across scopes" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o

      assert o.role(:leader).inherited?(d.role(:create))
      assert o.role(:leader).inherited?(d.role(:read))
      assert o.role(:leader).inherited?(d.role(:update))
      assert o.role(:leader).inherited?(d.role(:destroy))

      assert_not o.role(:member).inherited?(d.role(:create))
      assert o.role(:member).inherited?(d.role(:read))
      assert_not o.role(:member).inherited?(d.role(:update))
      assert_not o.role(:member).inherited?(d.role(:destroy))
    end
  end
end
