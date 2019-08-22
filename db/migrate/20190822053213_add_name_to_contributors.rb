class AddNameToContributors < ActiveRecord::Migration[5.2]
  def change
    add_column :contributors, :name, :string
  end
end
