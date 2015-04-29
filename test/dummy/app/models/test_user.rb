class TestUser < ActiveRecord::Base
  include ::Rollenspiel::RoleOwner
end
