class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :iterations
  has_many :user_stories

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
