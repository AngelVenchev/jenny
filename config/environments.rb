require 'sinatra'

configure :development do
  set :database, 'sqlite:///dev.db'
  set :show_exceptions, true
end

configure :test do
  set :database, 'sqlite:///test.db'
  set :show_exceptions, true
end
