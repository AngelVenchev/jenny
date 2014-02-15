class AuthenticationController < ApplicationController
  def register_new(params)
    haml :"auth/register"
  end

  def register(params)
    user = User.init(params)
    # catch exception
    if user.save
      session[:user_id] = user.id
      puts "in auth"
      puts user.id
      redirect '/'
    else
      # add flash message
      redirect 'auth/register'
    end
  end

  def show_login(params)
    haml :"auth/login"
  end

  def login(params)
    user = User.authenticate(params[:username],params[:password])
    # add flash message for both
    if user
      session[:user_id] = user.id
      redirect "/"
    else
      redirect 'auth/login'
    end
  end
end
