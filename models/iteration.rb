class Iteration < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end