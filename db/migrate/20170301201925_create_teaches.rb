class CreateTeaches < ActiveRecord::Migration[5.0]
  def change
    create_table :teaches do |t|
      t.references :subject, foreign_key: true
      t.references :teacher

      t.timestamps
    end
    add_index :teaches, [:subject_id, :teacher_id], unique: true
    add_foreign_key :teaches, :users, column: :teacher_id
  end
end
