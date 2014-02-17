#\ -p 9393

require 'sinatra/base'
require 'sinatra/flash'
require 'haml'

require './lib/router'
require './lib/app'

Dir["./models/*.rb"].each { |file| require file.gsub '.rb', '' }
Dir["./controllers/*.rb"].each { |file| require file.gsub '.rb', '' }

require './config/routes'

map "/public" do
  run Rack::Directory.new("./public")
end

map('/') { run App }

