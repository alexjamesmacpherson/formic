class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments do |t|
      t.references :school, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
