module Rollenspiel
  class Role
    def initialize options={}
      @options = options || {}
    end

    def name
      @options[:name]
    end

    def grantee
      @options[:grantee]
    end

    def grantee_type
      @options[:grantee_type] || @options[:grantee].try(:class).try(:name)
    end

    def provider
      @options[:provider]
    end

    def provider_type
      @options[:provider_type] || @options[:provider].try(:class).try(:name)
    end

    def grant! grantee
      conditions = persisted_role_conditions.merge(grantee: grantee)
      PersistedRole.find_or_initialize_by(conditions).save!
    end

    def granted?
      PersistedRole.where(persisted_role_conditions).exists?
    end

    def all
      PersistedRole.where(persisted_role_conditions)
    end

    def grantees
      persisted_roles = PersistedRole.where(persisted_role_conditions)
      if grantee_type
        grantee_type.constantize.where(id: persisted_roles.select(:grantee_id))
      else
        RoleGrantee.registered_grantees.map do |model|
          model.constantize.where(id: persisted_roles.where(grantee_type: model).select(:grantee_id))
        end.flatten
      end
    end

    def providers
      persisted_roles = PersistedRole.where(persisted_role_conditions)
      if provider_type
        provider_type.constantize.where(id: persisted_roles.select(:provider_id))
      else
        RoleProvider.registered_providers.map do |model|
          model.constantize.where(id: persisted_roles.where(provider_type: model).select(:provider_id))
        end.flatten
      end
    end

    def persisted_role_conditions
      conditions = {}
      conditions[:name] = name if name
      if grantee
        conditions[:grantee] = grantee
      elsif grantee_type
        conditions[:grantee_type] = grantee_type
      end
      if provider
        conditions[:provider] = provider
      elsif provider_type
        conditions[:provider_type] = provider_type
      end
      conditions
    end

    def to_s
      "#{self.class}(#{@options.inspect})"
    end
  end
end
