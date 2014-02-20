require 'date'

class Iteration < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true
  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def is_current?
    start_date < DateTime.now and end_date > DateTime.now
  end
end