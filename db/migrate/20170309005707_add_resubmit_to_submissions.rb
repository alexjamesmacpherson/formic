class AddResubmitToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :resubmit, :boolean, default: false
  end
end
