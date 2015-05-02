class CreateTestAnimals < ActiveRecord::Migration
  def change
    create_table :test_animals do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
