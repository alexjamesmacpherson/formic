class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.references :subject, foreign_key: true
      t.references :period, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :lessons, [:subject_id, :period_id], unique: true
    add_index :lessons, [:location_id, :period_id], unique: true
  end
end
