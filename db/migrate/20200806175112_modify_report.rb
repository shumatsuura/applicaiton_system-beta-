class ModifyReport < ActiveRecord::Migration[5.2]
  def change
    rename_column :reports, :application_id, :pre_application_id
  end
end
