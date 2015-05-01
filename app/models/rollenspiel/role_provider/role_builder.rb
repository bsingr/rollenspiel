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
      end

      class InstanceRoleBuilder
        def initialize record
          @record = record
        end

        def build role_name
          @record.roles.build name: role_name
        end
      end

      def initialize structure, role_builder
        @structure = structure
        @role_builder = role_builder
      end

      def build
        roles_by_key = {}
        @structure.layout[:roles].each do |role_or_name|
          if role_or_name.kind_of?(Role)
            roles_by_key[role_or_name] = role_or_name
          else
            roles_by_key[role_or_name] = @role_builder.build(role_or_name)
          end
        end
        @structure.layout[:inheritances].each do |role_or_name, inherits_roles|
          inherits_roles.each do |inherits_role|
            roles_by_key[role_or_name].inherit roles_by_key[inherits_role]
          end
        end
        roles_by_key
      end

      def create
        build.each {|name, role| role.save! }
      end
    end
  end
end
