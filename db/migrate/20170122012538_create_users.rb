class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :school, foreign_key: true
      t.string :email
      t.integer :user_group
      t.string :name
      t.text :bio
      t.text :address

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
