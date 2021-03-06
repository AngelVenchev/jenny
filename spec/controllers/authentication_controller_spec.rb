require 'spec_helper'

describe AuthenticationController do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: './test.db')
  end

  describe 'the signin process', type: :feature do

    before do
      user = User.init(
        username: 'user',
        email: 'user@example.com',
        password: 'password')
      user.save
    end

    it 'opens login page' do
      get '/auth/login'
      last_response.should be_ok
      last_response.body.include?("id='login_form'").should == true
    end

    it 'signs me in' do
      params =
      {
        username: 'user',
        password: 'password'
      }
      post '/auth/login', params
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should == 'http://example.org/projects'
    end

    it "doesn't sign me in with invalid credentials" do
      params =
      {
        username: 'invalid_user',
        password: 'password'
      }
      post '/auth/login', params
      last_response.should be_redirect

      follow_redirect!
      last_request.url.should == 'http://example.org/auth/login'
    end

    after do
      user = User.find_by username: 'user'
      user.destroy if user
    end
  end

  describe 'the signout process', type: :feature do

    before do
      params =
      {
        username: 'user',
        password: 'password'
      }
      post '/auth/login', params
    end

    it 'signs me out' do
      get '/auth/logout'
      last_response.should be_redirect

      follow_redirect!
      last_request.url.should == 'http://example.org/'
    end
  end

  describe 'the register process', type: :feature do

    let(:params) do
      {
        username: 'new_user',
        email: 'test@gmail.com',
        password: 'test'
      }
    end

    it 'shows register page' do
      get '/auth/register'
      last_response.should be_ok
      last_response.body.include?("id='register_form'").should == true
    end

    it 'creates a new user' do
      post '/auth/register', params
      last_response.should be_redirect

      follow_redirect!

      user = User.find_by username: 'new_user'
      user.should_not.nil?
    end

    it "doesn't create the same user twice" do
      post '/auth/register', params
      post '/auth/register', params
      last_response.should be_redirect

      follow_redirect!
      last_request.url.should == 'http://example.org/auth/register'
    end

    after do
      User.delete_all
    end
  end
end
