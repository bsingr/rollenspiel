module Rollenspiel
  module RoleGrantee
    extend ActiveSupport::Concern

    def self.registered_grantees
      @registered_grantees ||= []
    end

    included do
      RoleGrantee.registered_grantees << name

      scope :by_role, ->(options) {
        Role.new(options.merge(grantee_type: name)).grantees
      }

      # @param [#to_s] role_name
      # @param [#to_s, #to_id] provider_or_class
      # @return [TrueClass, FalseClass] true when the role is granted
      def role? role_name, provider_or_class=nil
        options = {name: role_name, grantee: self}
        if provider_or_class.respond_to? :id
          options[:provider] = provider_or_class
        elsif provider_or_class
          options[:provider_type] = provider_or_class
        end
        Role.new(options).granted?
      end

      # @param [#to_id, #to_s] role_provider_or_class
      # @return [TrueClass, FalseClass] true when a role of a provider is granted
      def role_in? provider_or_class
        options = {grantee: self}
        if provider_or_class.respond_to? :id
          options[:provider] = provider_or_class
        else
          options[:provider_type] = provider_or_class
        end
        Role.new(options).granted?
      end
    end
  end
end
