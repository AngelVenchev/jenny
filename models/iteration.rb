require 'date'

# Iteration model
class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :user_stories

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  def current?
    start_date < DateTime.now && end_date > DateTime.now
  end
end
