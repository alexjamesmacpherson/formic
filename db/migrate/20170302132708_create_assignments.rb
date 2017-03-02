class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.references :subject, foreign_key: true
      t.string :name
      t.text :information
      t.datetime :due

      t.timestamps
    end
  end
end
