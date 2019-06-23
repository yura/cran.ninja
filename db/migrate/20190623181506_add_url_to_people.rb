class AddUrlToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :url, :string
  end
end
