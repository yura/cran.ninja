class AddMoreFieldsToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :packages_depends, :text
    add_column :packages, :packages_suggests, :text
    add_column :packages, :packages_imports, :text
    add_column :packages, :packages_enhances, :text
    add_column :packages, :packages_linking_to, :text
    add_column :packages, :packages_priority, :string
    add_column :packages, :packages_license, :string
    add_column :packages, :packages_license_restricts_use, :string
    add_column :packages, :packages_license_is_foss, :string
    add_column :packages, :packages_needs_compilation, :string
    add_column :packages, :packages_os_type, :string
    add_column :packages, :packages_archs, :string
    add_column :packages, :packages_md5sum, :string
    add_column :packages, :packages_path, :string
    add_column :packages, :packages_content, :text
  end
end
