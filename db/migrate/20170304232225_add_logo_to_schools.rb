class AddLogoToSchools < ActiveRecord::Migration[5.0]
  def change
    add_column :schools, :logo, :string
  end
end
