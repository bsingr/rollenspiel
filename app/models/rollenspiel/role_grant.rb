module Rollenspiel
  class RoleGrant < ActiveRecord::Base
    belongs_to :role
    belongs_to :grantee, polymorphic: true

    has_many :inherited_roles, through: :role

    validates_presence_of :role, :grantee
    validates_uniqueness_of :role_id, scope: [:grantee_id, :grantee_type]
    validates_inclusion_of :grantee_type, in: RoleGrantee.registered_grantees

    after_save :run_callbacks
    after_destroy :run_callbacks

    def run_callbacks
      self.class.callbacks.each do |callback|
        callback.apply self if callback.matches? self.role
      end
    end

    def self.register_callback callback
      @callbacks ||= []
      @callbacks << callback unless @callbacks.find{|c| c == callback}
    end

    def self.callbacks
      @callbacks ||= []
    end
  end
end
