class AddPackagesHasNewFieldToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :packages_has_new_field, :boolean, default: false
  end
end
