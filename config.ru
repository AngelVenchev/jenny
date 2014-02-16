#\ -p 9393

require 'sinatra/base'
require 'haml'

require './lib/router'
require './lib/app'

require './models/environments'
require './models/user'

require './controllers/application_controller'
require './controllers/authentication_controller'
require './controllers/home_controller'

require './config/routes'

map('/') { run App }
