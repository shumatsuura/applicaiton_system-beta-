class AddSlackIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_member_id, :string
  end
end
