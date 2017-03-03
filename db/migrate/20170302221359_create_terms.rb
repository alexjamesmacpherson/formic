class CreateTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :terms do |t|
      t.references :school, foreign_key: true
      t.string :name
      t.datetime :starts
      t.datetime :ends
      t.datetime :halfterm_starts
      t.datetime :halfterm_ends

      t.timestamps
    end
  end
end
