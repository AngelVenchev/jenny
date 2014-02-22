# Task model
class Task < ActiveRecord::Base
  belongs_to :user_story
  belongs_to :executor, class_name: 'User'
  belongs_to :tester, class_name: 'User'

  validates :title, uniqueness: { case_sensitive: false }, presence: true
end
