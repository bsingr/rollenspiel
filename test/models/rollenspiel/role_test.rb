require 'test_helper'

module Rollenspiel
  class RoleTest < ActiveSupport::TestCase
    test "finds role grantees of different type" do
      g1 = TestUser.create!
      g2 = TestAnimal.create!

      foo = Role.new(name: :foo)
      foo.grant!(g1)
      foo.grant!(g2)

      bar = Role.new(name: :bar)
      bar.grant!(g1)

      assert_equal g1, foo.grantees[0]
      assert_equal g2, foo.grantees[1]
      assert_equal g1, bar.grantees[0]
      assert_equal nil, bar.grantees[1]
    end

    test "finds role providers of different type" do
      p1 = TestOrganization.create!
      p2 = TestDepartment.create!

      foo = Role.new(name: :foo, provider: p1)
      foo.grant!(TestUser.create!)

      bar = Role.new(name: :foo, provider: p2)
      bar.grant!(TestUser.create!)

      assert_equal p1, foo.providers[0]
      assert_equal nil, foo.providers[1]
      assert_equal p2, bar.providers[0]
      assert_equal nil, bar.providers[1]
    end
  end
end
