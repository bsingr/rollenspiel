class CreateTestDepartments < ActiveRecord::Migration
  def change
    create_table :test_departments do |t|
      t.string :name
      t.references :test_organization, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
