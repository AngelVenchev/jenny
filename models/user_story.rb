# UserStory model
class UserStory < ActiveRecord::Base
  belongs_to :project
  belongs_to :iteration
  has_many :tasks

  validates :title, uniqueness: { case_sensitive: false }, presence: true
end
