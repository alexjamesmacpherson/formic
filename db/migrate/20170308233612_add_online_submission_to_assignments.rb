class AddOnlineSubmissionToAssignments < ActiveRecord::Migration[5.0]
  def change
    add_column :assignments, :submit_online, :boolean, default: true
  end
end
