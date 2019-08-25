class AddAuthorWithErrorsToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :author_with_errors, :boolean, default: false
    add_column :packages, :maintainer_with_errors, :boolean, default: false
  end
end
