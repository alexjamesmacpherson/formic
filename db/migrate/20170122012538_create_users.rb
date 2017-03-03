class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :school, foreign_key: true
      t.references :tutor
      t.string :email
      t.integer :group, default: 1
      t.string :name
      t.text :bio, default: ''

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
