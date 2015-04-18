class RemoveFavProjectsFromEmailNotifications < ActiveRecord::Migration
  def up
    remove_column :email_notifications, :fav_projects
  end

  def down
    add_column :email_notifications, :fav_projects, :boolean
  end
end
