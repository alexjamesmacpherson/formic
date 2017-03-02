class CreateTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :terms do |t|
      t.references :school, foreign_key: true
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :halfterm_start_date
      t.datetime :halfterm_end_date

      t.timestamps
    end
  end
end
