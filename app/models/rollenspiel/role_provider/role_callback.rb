module Rollenspiel
  module RoleProvider
    class RoleCallback
      attr_reader :role_name, :provider_type

      def initialize block
        @block = block
      end

      def scope_to_role role
        @role_name = role.name.try(:to_s)
        @provider_type = role.provider_type
      end

      def matches? role
        @role_name == role.name && @provider_type == role.provider_type
      end

      def apply thing
        @block.call(thing)
      end

      def ==other
        role_name == other.role_name && provider_type == other.provider_type
      end
    end
  end
end
