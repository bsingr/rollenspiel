require 'test_helper'

module Rollenspiel
  class RoleStructureTest < ActiveSupport::TestCase
    test "list" do
      s = RoleScope::RoleStructure.new.tap do |builder|
        builder.roles :foo, :bar
      end
      assert_equal [:foo, :bar], s.layout[:roles]
      assert_equal ({}), s.layout[:inheritances]
    end

    test "hash" do
      s = RoleScope::RoleStructure.new.tap do |builder|
        builder.role :lala
        builder.role :foo, inherits: [:bar, :baz]
        builder.role :bakko, inherits: [:brazzo]
      end
      assert_equal [:lala, :foo, :bar, :baz, :bakko, :brazzo], s.layout[:roles]
      assert_equal ({foo: [:bar, :baz], bakko: [:brazzo]}), s.layout[:inheritances]
    end

    test "proc with list" do
      s = RoleScope::RoleStructure.new.tap do |builder|
        builder.role :foo, :bar
      end
      assert_equal [:foo, :bar], s.layout[:roles]
      assert_equal ({}), s.layout[:inheritances]
    end

    test "proc with hash" do
      s = RoleScope::RoleStructure.new.tap do |builder,r|
        builder.role :lala
        builder.role :foo, inherits: [:bar]
      end
      assert_equal [:lala, :foo, :bar], s.layout[:roles]
      assert_equal ({foo: [:bar]}), s.layout[:inheritances]
    end
  end
end
