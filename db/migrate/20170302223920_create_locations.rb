class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.references :school, foreign_key: true
      t.string :name

      t.timestamps
    end
    add_index :locations, [:school_id, :name], unique: true
  end
end
