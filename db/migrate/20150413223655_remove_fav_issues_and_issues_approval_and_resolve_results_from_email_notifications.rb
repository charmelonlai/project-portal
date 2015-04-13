class RemoveFavIssuesAndIssuesApprovalAndResolveResultsFromEmailNotifications < ActiveRecord::Migration
  def up
    remove_column :email_notifications, :fav_issues
    remove_column :email_notifications, :issues_approval
    remove_column :email_notifications, :resolve_results
  end

  def down
    add_column :email_notifications, :resolve_results, :boolean
    add_column :email_notifications, :issues_approval, :boolean
    add_column :email_notifications, :fav_issues, :boolean
  end
end
