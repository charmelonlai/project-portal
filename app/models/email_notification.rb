class EmailNotification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :proj_approval
  validates_uniqueness_of :user_id
end
