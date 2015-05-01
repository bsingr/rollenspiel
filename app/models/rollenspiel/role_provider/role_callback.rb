module Rollenspiel
  module RoleProvider
    class RoleCallback
      def initialize block
        @block = block
      end

      def scope_to_role role
        @role_name = role.name
        @provider_type = role.provider_type
      end

      def matches? role
        @role_name == role.name && @provider_type == role.provider_type
      end

      def apply thing
        @block.call(thing)
      end
    end
  end
end
