class CreatePeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :periods do |t|
      t.references :school, foreign_key: true
      t.string :name
      t.datetime :starts
      t.datetime :ends

      t.timestamps
    end
  end
end
