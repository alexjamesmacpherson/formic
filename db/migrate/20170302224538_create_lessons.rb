class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.references :subject, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
