class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.date :published_at
      t.text :title
      t.text :description

      t.timestamps
    end
  end
end
