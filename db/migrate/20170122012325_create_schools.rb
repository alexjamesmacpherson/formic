class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :motto
      t.text :address
      t.string :phone

      t.timestamps
    end
  end
end
