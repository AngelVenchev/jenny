class HomeController < ApplicationController
  def index(params)
    user_id = session[:user_id]
    user = User.find_by id: user_id
    haml :index, :layout => :'home_layout', locals: {user: user}
  end
end
