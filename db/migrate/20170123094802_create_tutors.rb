class CreateTutors < ActiveRecord::Migration[5.0]
  def change
    create_table :tutors do |t|
      t.references :tutor
      t.references :pupil

      t.timestamps
    end
    add_index :tutors, [:tutor_id, :pupil_id], unique: true
    add_foreign_key :tutors, :users, column: :tutor_id
    add_foreign_key :tutors, :users, column: :pupil_id
  end
end
