require 'rubygems'
require 'sinatra'
require 'json'

require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-identity'

require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

class User < ActiveRecord::Base
end

class Identity < OmniAuth::Identity::Models::ActiveRecord
  belongs_to :user

  validates :email, :presence => true, :uniqueness => true, :case_sensitive => false
  validates :password, :presence => true, :confirmation => true
  validates :password_confirmation, :presence => true
end

configure do
  set :sessions, true
  set :inline_templates, true
end
use OmniAuth::Builder do
  provider :github, 'c52763891c06b6514fdb','138d12517ae2bb6c8029c8bcbf439e54e3103b36'
  provider :facebook, '545751542206750','710b62cf82d12c3d363670b6501a120c'
  provider :identity, :fields => [:email]
end

get "/" do
  @authenticated = session[:authenticated]
  haml :"index"
end

get '/auth/:provider/callback' do
  #session[:authenticated] = true; according to params
  erb "<h1>#{params[:provider]}</h1>
       <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

get '/auth/:provider/deauthorized' do
  erb "#{params[:provider]} has deauthorized this app."
end

get '/protected' do
  throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
  erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
       <a href='/logout'>Logout</a>"
end

get '/logout' do
  session[:authenticated] = false
  redirect '/'
end