require 'sinatra/base'
require 'sinatra/flash'
require_relative '../models/user.rb'


class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  set :views, File.expand_path('../../views', __FILE__)
  enable :sessions, :method_override

  get "/" do
    @title = "Welcome to Jenny"
    if session[:user_id]
      haml :"index"
    else
      redirect '/user/login'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/'
  end
end
