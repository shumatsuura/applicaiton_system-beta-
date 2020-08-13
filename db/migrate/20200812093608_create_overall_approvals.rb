class CreateOverallApprovals < ActiveRecord::Migration[5.2]
  def change
    create_table :overall_approvals do |t|
      t.integer :pre_application_id
      t.string :status, default: "承認待ち"

      t.timestamps
    end
  end
end
