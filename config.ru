#\ -p 9393

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'haml'

require './config/environments'

require './lib/router'
require './lib/request_helper'
require './lib/app'

Dir["./models/*.rb"].each { |file| require file.gsub '.rb', '' }
Dir["./controllers/*.rb"].each { |file| require file.gsub '.rb', '' }

require './config/routes'

map "/public" do
  run Rack::Directory.new("./public")
end

map('/') { run App }
