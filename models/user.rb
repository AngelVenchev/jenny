require 'digest/sha3'

# User module also used for authentication
class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_many :tasks_as_executor, foreign_key: 'executor_id', class_name: 'Task'
  has_many :tasks_as_tester, foreign_key: 'tester_id', class_name: 'Task'

  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates :password, presence: true
  validates :email, presence: true, uniqueness: true

  def self.init(params)
    username = params[:username]
    email = params[:email]
    password = Digest::SHA3.hexdigest(params[:password])
    new(username: username, email: email, password: password)
  end

  def self.authenticate(username, password)
    pass = Digest::SHA3.hexdigest(password)
    User.find_by password: pass, username: username
  end
end
