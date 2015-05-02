class TestDepartment < ActiveRecord::Base
  belongs_to :test_organization

  role_provider
end
