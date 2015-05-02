require 'test_helper'

module Rollenspiel
  class RoleProviderTest < ActiveSupport::TestCase
    test "finds by role grantees" do
      o = TestOrganization.create!
      u1 = TestUser.create!
      u2 = TestUser.create!

      o.role(:leader).grant!(u1)

      assert_equal o, TestOrganization.by_role(grantee: u1).first
      assert_equal nil, TestOrganization.by_role(grantee: u2).first
    end

    test "finds by role grantees and role_name" do
      o = TestOrganization.create!
      u1 = TestUser.create!
      u2 = TestUser.create!
      o.role(:leader).grant!(u1)
      o.role(:member).grant!(u2)

      assert_equal o, TestOrganization.by_role(grantee: u1, name: :leader).first
      assert_equal nil, TestOrganization.by_role(grantee: u1, name: :member).first
      assert_equal nil, TestOrganization.by_role(grantee: u2, name: :leader).first
      assert_equal o, TestOrganization.by_role(grantee: u2, name: :member).first
    end

    test "finds role grantees" do
      o = TestOrganization.create!
      u1 = TestUser.create!
      u2 = TestUser.create!
      o.role(:leader).grant!(u1)
      o.role(:member).grant!(u1)
      o.role(:member).grant!(u2)

      assert_equal 1, o.grantees_of_role(:leader).size
      assert_equal u1, o.grantees_of_role(:leader).first
      assert_equal 2, o.grantees_of_role(:member).size
      assert_equal u1, o.grantees_of_role(:member).first
      assert_equal u2, o.grantees_of_role(:member).last
    end
  end
end
