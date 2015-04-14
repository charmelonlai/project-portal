class DropCommentsTable < ActiveRecord::Migration
  def up
    drop_table :comments
    #remove_index :comments, :user_id
    #remove_index :comments, :column => [:commentable_id, :commentable_type]
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
