class CreateParents < ActiveRecord::Migration[5.0]
  def change
    create_table :parents do |t|
      t.references :parent
      t.references :child

      t.timestamps
    end
    add_index :parents, [:parent_id, :child_id], unique: true
    add_foreign_key :parents, :users, column: :parent_id
    add_foreign_key :parents, :users, column: :child_id
  end
end
