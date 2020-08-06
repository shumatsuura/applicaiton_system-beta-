class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :department, :string
    add_column :users, :team, :string
    add_column :users, :position, :string
    add_column :users, :office, :string
    add_column :users, :admin, :boolean, default: false
  end
end
