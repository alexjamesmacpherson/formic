class CreateParents < ActiveRecord::Migration[5.0]
  def change
    create_table :parents do |t|
      t.references :parent, foreign_key: true
      t.references :child, foreign_key: true

      t.timestamps
    end
    add_index :parents, [:parent_id, :child_id], unique: true
  end
end
