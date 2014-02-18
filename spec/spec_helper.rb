require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/flash'
# require 'haml'
require 'rack/test'
require 'rspec'
require 'capybara/rspec'
require 'i18n'

# require '../config/environments'

require '../lib/router'
require '../lib/app'

Dir["../models/*.rb"].each { |file| require file.gsub '.rb', '' }
Dir["../controllers/*.rb"].each { |file| require file.gsub '.rb', '' }

require '../config/routes'

I18n.enforce_available_locales = false
