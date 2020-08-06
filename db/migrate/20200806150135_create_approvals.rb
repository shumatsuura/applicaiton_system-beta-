class CreateApprovals < ActiveRecord::Migration[5.2]
  def change
    create_table :approvals do |t|
      t.integer :pre_application_id
      t.integer :user_id
      t.boolean :judge
      t.integer :order

      t.timestamps
    end
  end
end
