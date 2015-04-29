module Rollenspiel
  module RoleScope
    class RoleBuilder
      def initialize structure
        @structure = structure
      end

      def build record
        roles_by_key = {}
        @structure.layout[:roles].each do |role_or_name|
          if role_or_name.kind_of?(Role)
            roles_by_key[role_or_name] = role_or_name
          else
            roles_by_key[role_or_name] = record.roles.build name: role_or_name
          end
        end
        @structure.layout[:inheritances].each do |role_or_name, inherits_roles|
          inherits_roles.each do |inherits_role|
            roles_by_key[role_or_name].inherit roles_by_key[inherits_role]
          end
        end
        roles_by_key
      end

      def create record
        build(record).each {|name, role| role.save! }
      end
    end
  end
end
