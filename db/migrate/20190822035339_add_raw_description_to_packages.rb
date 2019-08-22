class AddRawDescriptionToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :raw_description, :text
  end
end
