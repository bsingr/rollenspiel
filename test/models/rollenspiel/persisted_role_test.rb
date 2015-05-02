require 'test_helper'

module Rollenspiel
  class PersistedRoleTest < ActiveSupport::TestCase
    test "creates without provider" do
      u = TestUser.new
      r = PersistedRole.create! name: 'manager', grantee: u
      assert r.grantee
      assert_not r.provider
      assert_not r.provider_type
    end

    test "creates with provider_type" do
      u = TestUser.new
      r = PersistedRole.create! name: 'manager', grantee: u, provider_type: TestOrganization
      assert_equal r.grantee, u
      assert_not r.provider
      assert_equal r.provider_type, TestOrganization.name
    end

    test "creates with provider" do
      o = TestOrganization.new
      u = TestUser.new
      r = PersistedRole.create! name: 'manager', grantee: u, provider: o
      assert_equal r.grantee, u
      assert_equal r.provider, o
      assert_equal r.provider_type, TestOrganization.name
    end
  end
end
