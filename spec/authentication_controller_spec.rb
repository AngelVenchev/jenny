require './spec_helper'

describe AuthenticationController, :type => :controller do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "../test.db"
    Capybara.app = app
  end

  describe "the signin process", :type => :feature do
    before do
      user = User.init(username: 'user', email: 'user@example.com', :password => 'password')
      user.save
    end

    it "signs me in" do
      post '/auth/login', {username:'user', password:'password'}

      #TODO: debug and show response object..
      # body and stuff
      last_response.status.should == 302 #redirect
    end

    after do
      user = User.find_by username: 'user'
      user.destroy
    end
  end
end
