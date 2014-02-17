require 'digest/sha3'
require 'date'

class User < ActiveRecord::Base
  has_and_belongs_to_many :projects

  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates :password, presence: true
  validates :email, presence: true, uniqueness: true

  def self.init(params)
    username = params[:username]
    email = params[:email]
    password = Digest::SHA3.hexdigest(params[:password])
    user = new(username: username, email: email, password: password)
  end

  def self.authenticate(username, password)
    pass = Digest::SHA3.hexdigest(password)
    user = User.find_by password:pass,username:username
  end
end
