class DropFavoritesTable < ActiveRecord::Migration
  def up
    drop_table :favorites
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
