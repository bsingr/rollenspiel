class CreateRollenspielRoles < ActiveRecord::Migration
  def change
    create_table :rollenspiel_roles do |t|
      t.string :name
      t.references :scope, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
