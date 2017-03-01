class AddGradesToStudy < ActiveRecord::Migration[5.0]
  def change
    add_column :studies, :target, :string, default: ''
    add_column :studies, :expected, :string, default: ''
  end
end
