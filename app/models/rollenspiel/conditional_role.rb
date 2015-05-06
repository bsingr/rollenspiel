module Rollenspiel
  class ConditionalRole
    def self.register options

    end

    ConditionalRole.register do |grantee, provider|
      when: Role.new(name: 'owner', grantee: grantee, provider_type: TestDepartment, provider_id: AAA),
      and: Role.new(name: 'member', grantee: provider, provider_type: TestDepartment, provider_id: AAA)
      then: Role.new(name: 'read', grantee: grantee, provider: provider),
    end


    # edit TestUser(1)
    ConditionalRole.register(:edit) do |grantee, provider, equal_id|
      [
        {
          name: 'owner',
          grantee: grantee,
          provider_type: TestOrganization,
          provider_id: equal_id
        },
        {
          name: 'member',
          grantee: provider,
          provider_type: TestOrganization,
          provider_id: equal_id
        }
      ]
    end

    # edit TestOrganization(1)
    ConditionalRole.register(:edit) do |grantee, provider|
      [
        {
          name: 'owner',
          grantee: grantee,
          provider: provider
        }
      ]
    end

    # edit TestDepartment(1)
    ConditionalRole.register(:edit) do |grantee, provider|
      [
        {
          name: 'owner',
          grantee: grantee,
          provider: provider.test_organization
        }
      ]
    end

    def granted? :read, owner, member, provider
      PersistedRole.where(:grantee => owner, name: 'owner', provider => provider).exists?
      && PersistedRole.where(:grantee => member, name: 'member', provider => provider).exists?
    end
  end
end
