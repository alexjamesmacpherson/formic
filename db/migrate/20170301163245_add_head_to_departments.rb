class AddHeadToDepartments < ActiveRecord::Migration[5.0]
  def change
    add_reference :departments, :head
    add_foreign_key :departments, :users, column: :head_id
  end
end
