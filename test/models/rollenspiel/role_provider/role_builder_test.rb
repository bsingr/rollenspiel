require 'test_helper'

module Rollenspiel
  class RoleBuilderTest < ActiveSupport::TestCase
    test "build" do
      s = RoleProvider::RoleStructure.new.tap do |builder|
        builder.roles :foo, :bar
      end
      b = RoleProvider::RoleBuilder.new(s)
      record = ::TestOrganization.new
      roles_by_key = b.build(record)
      assert_equal 'foo', roles_by_key[:foo].name
      assert_equal record, roles_by_key[:foo].provider
      assert_equal 'bar', roles_by_key[:bar].name
      assert_equal record, roles_by_key[:bar].provider
    end
  end
end