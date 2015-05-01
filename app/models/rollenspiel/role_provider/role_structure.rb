module Rollenspiel
  module RoleProvider
    class RoleStructure
      def initialize
        @roles = []
        @inheritances = {}
        @callbacks = {on_grant: {}}
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
        if on_grant = options[:on_grant]
          roles.each do |role|
            @callbacks[:on_grant][role] = RoleCallback.new(on_grant)
          end
        end
      end
      alias :role :roles

      def layout
        {
          inheritances: @inheritances,
          roles: @roles,
          callbacks: @callbacks
        }
      end
    end
  end
end
