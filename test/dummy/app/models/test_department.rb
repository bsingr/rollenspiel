class TestDepartment < ActiveRecord::Base
  belongs_to :test_organization

  #role_provier
end


# ImplicitRole.register TestDepartment.role(:owner) => TestDepartment.role(:read),
#                       TestDepartment.role(:owner) => TestDepartment.role(:write)
# -
#   role:
#     name: owner
#     grantee_type: User
#     grantee_id: 1
#     provider_type: TestOrganization
#     provider_id: 1
#   implicit:
#     -
#       name: read FIX
#       grantee_type: User SAME
#       grantee_id: 1 SAME
#       provider_type: User FIX
#       provider_id: 2 ???
#     -
#       name: read FIX
#       grantee_type: User SAME
#       grantee_id: 1 SAME
#       provider_type: TestOrganization FIX
#       provider_id: 1 SAME
#     -
#       name: read FIX
#       grantee_type: User SAME
#       grantee_id: 1 SAME
#       provider_type: TestDepartment FIX
#       provider_id: 1 ???

