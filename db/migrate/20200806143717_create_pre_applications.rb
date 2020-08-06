class CreatePreApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :pre_applications do |t|
      t.references :user, foreign_key: true
      t.string :genre
      t.string :item
      t.text :description
      t.integer :amount

      t.timestamps
    end
  end
end
