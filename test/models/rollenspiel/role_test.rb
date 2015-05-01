require 'test_helper'

module Rollenspiel
  class RoleTest < ActiveSupport::TestCase
    test "creates and inherits" do
      r = Rollenspiel::Role.create! name: 'manager'
      r.inherit! Role.new(name: 'read')

      assert r.inherited? 'read'
      assert_not r.inherited? 'foo'

      assert_not r.provider
    end

    test "knows its provider" do
      o = TestOrganization.create!
      assert o.role(:read).provider
    end
  end
end
