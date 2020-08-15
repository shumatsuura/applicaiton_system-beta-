class CreateRemoteWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :remote_works do |t|
      t.references :user
      t.date :remote_date

      t.timestamps
    end
  end
end
