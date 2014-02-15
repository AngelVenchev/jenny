class HomeController < ApplicationController
  def index(params)
    @test = "test"
    user_id = session[:user_id]
    user = User.find_by id: user_id
    @current_user = user.username if user
    haml :index
  end
end