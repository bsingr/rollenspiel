require 'test_helper'

module Rollenspiel
  class RoleGranteePerformanceTest < ActiveSupport::TestCase
     test "#role_in?" do
      n = 100

      u = TestUser.create!

      organizations = []
      ActiveRecord::Base.transaction do
        n.times do |i|
          o = TestOrganization.create! name: "org-#{i}"
          o.role(:read).grant_to! u
          organizations << o
        end
      end

      time = Benchmark.realtime do
        100.times do |i|
          u.role_in? organizations[i]
        end
      end

      expected_max_time = 0.1
      expected_max_time = 0.2 if RUBY_VERSION =~ /^1\./

      assert time < expected_max_time, "expected #{time} < #{expected_max_time}"
    end
  end
end if ENV['BENCHMARK']
