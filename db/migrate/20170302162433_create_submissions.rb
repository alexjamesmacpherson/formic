class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.references :assignment, foreign_key: true
      t.references :pupil
      t.string :file
      t.boolean :submitted, default: false
      t.datetime :submitted_at
      t.references :marker
      t.boolean :marked, default: false
      t.datetime :marked_at
      t.text :feedback
      t.integer :grade

      t.timestamps
    end
    add_index :submissions, [:assignment_id, :pupil_id], unique: true
    add_foreign_key :submissions, :users, column: :pupil_id
    add_foreign_key :submissions, :users, column: :marker_id
  end
end
