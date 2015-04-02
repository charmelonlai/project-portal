class AddSectorAndTypeToProject < ActiveRecord::Migration
  def change
    add_column :projects, :sector, :string
    add_column :projects, :project_type, :string
  end
end
