class AddParsedDescriptionToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :description_parsed, :boolean
  end
end
