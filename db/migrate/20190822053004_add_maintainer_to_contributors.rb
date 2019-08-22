class AddMaintainerToContributors < ActiveRecord::Migration[5.2]
  def change
    add_column :contributors, :maintainer, :boolean, default: false
    add_index :contributors, :maintainer
  end
end
