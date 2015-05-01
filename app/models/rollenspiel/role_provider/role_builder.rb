module Rollenspiel
  module RoleProvider
    class RoleBuilder
      class ClassRoleBuilder
        def initialize class_name
          @class_name = class_name
        end

        def build role_name
          Rollenspiel::Role.find_or_initialize_by name: role_name, provider_type: @class_name
        end

        def to_s
          "#{self.class}(#{@class_name})"
        end
      end

      class InstanceRoleBuilder
        def initialize record
          @record = record
        end

        def build role_name
          @record.provided_roles.build name: role_name
        end

        def to_s
          "#{self.class}(#{@record.inspect})"
        end
      end

      def initialize structure, role_builder
        @structure = structure
        @role_builder = role_builder
      end

      def build
        roles_by_key = {}
        @structure.layout[:roles].each do |role_or_name|
          if role_or_name.respond_to?(:id)
            roles_by_key[role_or_name] = role_or_name
          else
            roles_by_key[role_or_name] = @role_builder.build(role_or_name)
          end
        end
        @structure.layout[:inheritances].each do |role_or_name, inherits_roles|
          inherits_roles.each do |inherits_role_or_name|
            raise ArgumentError, "Role #{@role_builder} #{role_or_name} is not available" unless roles_by_key[role_or_name]
            if inherits_role_or_name.respond_to?(:id)
              roles_by_key[role_or_name].inherit inherits_role_or_name
            else
              roles_by_key[role_or_name].inherit roles_by_key[inherits_role_or_name]
            end
          end
        end
        @structure.layout[:callbacks][:on_grant].each do |role_or_name, role_callback|
          role = roles_by_key[role_or_name]
          role_callback.scope_to_role(role)
        end
        roles_by_key
      end

      def create
        build.each {|name, role| role.save! }
      end
    end
  end
end
