class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.boolean :seen, default: false
      t.string :message
      t.string :link

      t.timestamps
    end
  end
end
