module Rollenspiel
  class PersistedRole < ActiveRecord::Base
    belongs_to :provider, polymorphic: true
    belongs_to :grantee, polymorphic: true

    validates_presence_of :name, :grantee
    validates_uniqueness_of :name, scope: [:grantee_id, :grantee_type, :provider_id, :provider_type]
    validates_inclusion_of :provider_type, in: RoleProvider.registered_providers,
                                           allow_nil: true
    validates_inclusion_of :grantee_type, in: RoleGrantee.registered_grantees

    def to_s
      "#{self.class}(#{name}, #{grantee_type}, #{provider_type})"
    end
  end
end
