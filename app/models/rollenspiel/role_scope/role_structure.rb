module Rollenspiel
  module RoleScope
    class RoleStructure
      def initialize
        @roles = []
        @inheritances = {}
      end

      def roles *roles_with_options
        roles = roles_with_options.dup
        options = roles.last.kind_of?(Hash) ? roles.pop : {}
        @roles << roles
        @roles << options[:inherits] if options[:inherits]
        @roles.flatten!
        @roles.compact!
        @roles.uniq!
        if inherits = options[:inherits]
          roles.each do |role|
            @inheritances[role] = inherits
          end
        end
      end
      alias :role :roles

      def layout
        {
          inheritances: @inheritances,
          roles: @roles
        }
      end
    end
  end
end
