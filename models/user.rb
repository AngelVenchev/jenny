require 'sinatra'
require 'sinatra/activerecord'
require_relative './environments.rb'
require 'digest/sha3'
require 'date'

class User < ActiveRecord::Base
  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates :password, presence: true
  validates :email, presence: true

  def self.init(params)
    username = params[:username]
    email = params[:email]
    password = Digest::SHA3.hexdigest(params[:password])
    user = new(username: username, email: email, password: password)
  end

  def self.authenticate(username, password)
    pass = Digest::SHA3.hexdigest(password)
    user = User.all.first do |user|
      user.username == username and user.password == pass
    end
  end
end
