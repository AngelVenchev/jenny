class AuthenticationController < ApplicationController
  def new(params)
    haml :"auth/register", :layout => :'home_layout'
  end

  def register(params)
    user = User.init(params)
    if user.save
      flash[:notice] = "Successfully registered in Jenny with username: #{user.username}"
      session[:user_id] = user.id
      redirect '/projects'
    else
      flash[:error] = "Unable to register user with username: #{user.username}"
      redirect '/auth/register'
    end
  end

  def show(params)
    haml :"auth/login", :layout => :'home_layout'
  end

  def login(params)
    user = User.authenticate(params[:username],params[:password])
    if user
      flash[:notice] = "Successfully logged in to Jenny!"
      session[:user_id] = user.id
      redirect '/projects'
    else
      flash[:error] = "Wrong username and/or password!"
      redirect '/auth/login'
    end
  end

  def logout(params)
    session[:user_id] = nil
    flash[:notice] = "Successfully logged out of Jenny"
    redirect '/'
  end
end
