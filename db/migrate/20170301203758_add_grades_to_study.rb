class AddGradesToStudy < ActiveRecord::Migration[5.0]
  def change
    add_column :studies, :target, :integer
    add_column :studies, :expected, :integer
  end
end
