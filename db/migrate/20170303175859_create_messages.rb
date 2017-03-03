class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.references :sender
      t.text :text

      t.timestamps
    end
    add_foreign_key :messages, :users, column: :sender_id
  end
end
