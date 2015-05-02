class CreateRollenspiel < ActiveRecord::Migration
  def change
    create_table :rollenspiel_persisted_roles do |t|
      t.string :name, index: true, null: false, limit: 255
      t.integer :revoked, default: 0, limit: 1, null: false, index: true

      t.references :grantee, polymorphic: true, null: false#, index: true FIXME
      t.references :provider, polymorphic: true#, index: true FIXME

      t.timestamps null: false
    end
  end
end
