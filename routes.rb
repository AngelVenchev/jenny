require_relative './lib/router.rb'

Router.a do
  match '/user/register', controller: 'UserController' action: "register"
end