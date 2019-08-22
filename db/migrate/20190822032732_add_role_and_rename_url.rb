class AddRoleAndRenameUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :role, :string
    rename_column :people, :url, :comment
  end
end
