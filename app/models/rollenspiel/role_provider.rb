module Rollenspiel
  module RoleProvider
    extend ActiveSupport::Concern

    def self.registered_providers
      @registered_providers ||= []
    end

    class_methods do
      def role role_name
        Rollenspiel::Role.find_by_name_and_provider_type(role_name, name)
      end
    end

    included do
      RoleProvider.registered_providers << name

      scope :by_role, ->(options) {
        Role.new(options.merge(provider_type: name)).providers
      }

      # @param [#to_s] role_name
      # @return [Rollenspiel::Role] role
      def role role_name
        Role.new(name: role_name, provider: self)
      end

      # @return [Rollenspiel::Role] role
      def any_role
        Role.new(provider: self)
      end

      # @param [#to_s] role_name
      # @return [Array<Rollenspiel::RoleGrantee>] role_grantees
      def grantees_of_role role_name
        role(role_name).grantees
      end

      # @return [Array<Rollenspiel::RoleGrantee>] role_grantees
      def grantees_of_any_role
        any_role.grantees
      end
    end
  end
end
