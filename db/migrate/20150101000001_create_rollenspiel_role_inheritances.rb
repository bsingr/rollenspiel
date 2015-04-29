class CreateRollenspielRoleInheritances < ActiveRecord::Migration
  def change
    create_table :rollenspiel_role_inheritances do |t|
      t.references :role, index: true
      t.references :inherited_role, index: true

      t.timestamps null: false
    end

    add_foreign_key :rollenspiel_role_inheritances, :rollenspiel_roles
    add_foreign_key :rollenspiel_role_inheritances, :rollenspiel_roles, column: :inherited_role_id
  end
end
