class AddTitleToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :title, :string
  end
end
