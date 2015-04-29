class CreateRollenspielRoleOwnerships < ActiveRecord::Migration
  def change
    create_table :rollenspiel_role_ownerships do |t|
      t.references :role, index: true
      t.references :owner, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_foreign_key :rollenspiel_role_ownerships, :rollenspiel_roles
  end
end
