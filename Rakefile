require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'haml'

require './config/environments'

require './lib/router'
require './lib/request_helper'
require './lib/app'

Dir["./helpers/*.rb"].each { |file| require file.gsub '.rb', '' }
Dir["./models/*.rb"].each { |file| require file.gsub '.rb', '' }
Dir["./controllers/*.rb"].each { |file| require file.gsub '.rb', '' }

require './config/routes'
require 'sinatra/activerecord/rake'
