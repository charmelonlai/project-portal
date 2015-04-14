class RemoveCommentFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :comment
  end

  def down
    add_column :projects, :comment, :text
  end
end
