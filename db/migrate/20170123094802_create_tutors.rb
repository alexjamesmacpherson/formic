class CreateTutors < ActiveRecord::Migration[5.0]
  def change
    create_table :tutors do |t|
      t.references :tutor, foreign_key: true
      t.references :pupil, foreign_key: true

      t.timestamps
    end
    add_index :tutors, [:tutor_id, :pupil_id], unique: true
  end
end
