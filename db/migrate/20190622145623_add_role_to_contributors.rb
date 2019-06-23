class AddRoleToContributors < ActiveRecord::Migration[5.2]
  def change
    add_column :contributors, :role, :string
  end
end
