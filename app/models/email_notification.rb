class EmailNotification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :fav_projects, :proj_approval
  validates_uniqueness_of :user_id
end
