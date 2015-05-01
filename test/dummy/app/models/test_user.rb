class TestUser < ActiveRecord::Base
  include ::Rollenspiel::RoleGrantee
end
