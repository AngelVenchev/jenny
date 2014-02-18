class HomeController < ApplicationController
  def index(params)
    user_id = session[:user_id]
    user = User.find_by id: user_id
    haml :index, locals: {user: user}
  end
end
