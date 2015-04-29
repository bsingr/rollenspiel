require 'test_helper'

module Rollenspiel
  class RoleScopeTest < ActiveSupport::TestCase
    test "finds role owners" do
      o = TestOrganization.create!
      u1 = TestUser.create!
      u2 = TestUser.create!
      o.role(:leader).grant_to!(u1)
      o.role(:member).grant_to!(u1)
      o.role(:member).grant_to!(u2)

      assert_equal 1, o.owners_of_role(:leader).count
      assert_equal u1, o.owners_of_role(:leader).first
      assert_equal 2, o.owners_of_role(:member).count
      assert_equal u1, o.owners_of_role(:member).first
      assert_equal u2, o.owners_of_role(:member).last
    end

    test "finds indirect role owners" do
      o = TestOrganization.create!
      u = TestUser.create!
      o.role(:leader).grant_to!(u)

      assert_equal 1, o.indirect_owners_of_role(:read).count
      assert_equal u, o.indirect_owners_of_role(:read).first
    end

    test "finds indirect role owners across scopes" do
      o = TestOrganization.create!
      d = TestDepartment.create! test_organization: o

      u1 = TestUser.create!
      u2 = TestUser.create!
      o.role(:leader).grant_to!(u1)
      o.role(:member).grant_to!(u1)
      o.role(:member).grant_to!(u2)

      assert u1.role?(o.role(:leader))
      assert u1.role?(d.role(:create))

      assert_equal 1, d.indirect_owners_of_role(:create).count
      assert_equal u1, d.indirect_owners_of_role(:create).first
      assert_equal 2, d.indirect_owners_of_role(:read).count
      assert_equal u1, d.indirect_owners_of_role(:read).first
      assert_equal u2, d.indirect_owners_of_role(:read).last
    end

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
