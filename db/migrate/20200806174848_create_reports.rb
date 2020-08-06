class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :application_id
      t.integer :user_id

      t.timestamps
    end
  end
end
