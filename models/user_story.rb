class UserStory < ActiveRecord::Base
  belongs_to :project
  belongs_to :iteration

  validates :title, presence: true
end