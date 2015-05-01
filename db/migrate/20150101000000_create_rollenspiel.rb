class CreateRollenspiel < ActiveRecord::Migration
  def change
    create_table :rollenspiel_roles do |t|
      t.string :name
      t.references :provider, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :rollenspiel_role_grants do |t|
      t.references :role, index: true
      t.references :grantee, polymorphic: true, index: true

      t.timestamps null: false
    end

    create_table :rollenspiel_role_inheritances do |t|
      t.references :role, index: true
      t.references :inherited_role, index: true

      t.timestamps null: false
    end

    add_foreign_key :rollenspiel_role_inheritances, :rollenspiel_roles
    add_foreign_key :rollenspiel_role_inheritances, :rollenspiel_roles, column: :inherited_role_id

    add_foreign_key :rollenspiel_role_grants, :rollenspiel_roles
  end
end
