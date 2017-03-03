class CreateConverses < ActiveRecord::Migration[5.0]
  def change
    create_table :converses do |t|
      t.references :chat, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :converses, [:chat_id, :user_id], unique: true
  end
end
