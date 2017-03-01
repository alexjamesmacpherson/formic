class CreateStudies < ActiveRecord::Migration[5.0]
  def change
    create_table :studies do |t|
      t.references :subject, foreign_key: true
      t.references :pupil

      t.timestamps
    end
    add_index :studies, [:subject_id, :pupil_id], unique: true
    add_foreign_key :studies, :users, column: :pupil_id
  end
end
