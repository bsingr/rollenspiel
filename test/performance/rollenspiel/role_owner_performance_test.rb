require 'test_helper'

module Rollenspiel
  class RoleOwnerPerformanceTest < ActiveSupport::TestCase
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

      assert time < 0.1, "expected #{time} < 0.1"
    end
  end
end if ENV['BENCHMARK']
