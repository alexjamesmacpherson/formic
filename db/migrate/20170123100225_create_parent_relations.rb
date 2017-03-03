class CreateParentRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :parent_relations do |t|
      t.references :parent
      t.references :child

      t.timestamps
    end
    add_index :parent_relations, [:parent_id, :child_id], unique: true
    add_foreign_key :parent_relations, :users, column: :parent_id
    add_foreign_key :parent_relations, :users, column: :child_id
  end
end
