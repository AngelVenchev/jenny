class UserStory < ActiveRecord::Base
  belongs_to :project
  belongs_to :iteration
  has_many :tasks

  validates :title, presence: true
end