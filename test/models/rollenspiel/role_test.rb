require 'test_helper'

module Rollenspiel
  class RoleTest < ActiveSupport::TestCase
    test "creates and inherits" do
      r = Role.create! name: 'manager'
      r.inherit! Role.new(name: 'read')

      assert r.inherited? 'read'
      assert_not r.inherited? 'foo'

      assert_not r.provider
    end

    test "knows its provider" do
      o = TestOrganization.create!
      assert o.role(:read).provider
    end

    test "destroys when inherited to role is destroyed" do
      r1 = Role.create! name: "one"
      r2 = Role.create!(name: "two")
      r1.inherit! r2

      assert_difference("RoleInheritance.count", -1) do
        r1.destroy!
      end
    end

    test "destroys when inherited from role is destroyed" do
      r1 = Role.create! name: "one"
      r2 = Role.create!(name: "two")
      r1.inherit! r2

      assert_difference("RoleInheritance.count", -1) do
        r2.destroy!
      end
    end
  end
end
