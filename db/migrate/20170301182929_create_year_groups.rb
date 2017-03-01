class CreateYearGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :year_groups do |t|
      t.references :school, foreign_key: true
      t.string :name

      t.timestamps
    end
    add_reference :users, :year_group, foreign_key: true
    add_reference :subjects, :year_group, foreign_key: true
  end
end
