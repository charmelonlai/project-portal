class DropIssuesTable < ActiveRecord::Migration
  def up
    drop_table :issues
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
