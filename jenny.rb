require 'rubygems'
require 'sinatra'
require 'json'

require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

configure do
  set :sessions, true
  set :inline_templates, true
  set :port, 9393
end

get "/" do
  erb "wat?"
end
