class MoveCommentToContributors < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :role
    remove_column :people, :comment
    add_column :contributors, :comment, :text
  end
end
