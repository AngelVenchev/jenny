require_relative './application_controller.rb'

class UserController < ApplicationController

  get '/:operation' do
    haml :"user/#{params[:operation]}"
  end

  post '/:operation' do
    action(params)
  end

  get '/success/:user_id' do
    session[:user_id] = params[:user_id]
    redirect '/'
  end

  def action(params)
    login(params) if params[:operation] == "login"
    register(params) if params[:operation] == "register"
  end

  def login(params)
    user = User.authenticate(params[:username],params[:password])
    if user
      redirect "success/#{user.id}"
    else
      redirect 'login'
    end
  end

  def register(params)
    fields =
    {
      username: params[:username],
      email: params[:email],
      password: params[:password]
    }
    user = User.init(fields)
    if user.save
      redirect "/success/#{user.id}"
    else
      "shit"
    end
  end
end
