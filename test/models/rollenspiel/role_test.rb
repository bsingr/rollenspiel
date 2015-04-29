require 'test_helper'

module Rollenspiel
  class RoleTest < ActiveSupport::TestCase
    test "creates and inherits" do
      r = Rollenspiel::Role.create! name: 'manager'
      r.inherited_roles.create! name: 'read'
      assert r.inherited? 'read'
      assert_not r.inherited? 'foo'
    end
  end
end