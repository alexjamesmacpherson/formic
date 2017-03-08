class AddGradesToStudy < ActiveRecord::Migration[5.0]
  def change
    add_column :studies, :challenge_grade, :string
  end
end
