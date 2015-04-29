class CreateTestOrganizations < ActiveRecord::Migration
  def change
    create_table :test_organizations do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
