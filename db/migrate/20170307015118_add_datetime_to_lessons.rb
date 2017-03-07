class AddDatetimeToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :start_time, :datetime
    add_column :lessons, :end_time, :datetime
    add_index :lessons, [:subject_id, :start_time], unique: true
    add_index :lessons, [:location_id, :start_time], unique: true
  end
end
