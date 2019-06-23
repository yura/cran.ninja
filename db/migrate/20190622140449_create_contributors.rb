class CreateContributors < ActiveRecord::Migration[5.2]
  def change
    create_table :contributors do |t|
      t.references :package, index: true
      t.references :person, index: true
      t.integer :position
    end
  end
end
