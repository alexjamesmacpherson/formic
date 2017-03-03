class CreateUnreadMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :unread_messages do |t|
      t.references :message, foreign_key: true
      t.references :recipient

      t.timestamps
    end
    add_foreign_key :messages, :users, column: :recipient_id
  end
end
