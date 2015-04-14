class AddAdminNoteToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :admin_note, :string
  end
end
