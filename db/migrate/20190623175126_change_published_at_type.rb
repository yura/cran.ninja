class ChangePublishedAtType < ActiveRecord::Migration[5.2]
  def change
    change_column :packages, :published_at, :datetime
  end
end
