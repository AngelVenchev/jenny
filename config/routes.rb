Router.init do
  match method: :get, path: '/',
  controller: 'HomeController', action: 'index'

  match method: :get, path: '/auth/register',
  controller: 'AuthenticationController', action: 'new'

  match method: :post, path: '/auth/register',
  controller: 'AuthenticationController', action: 'register'

  match method: :get, path: '/auth/login',
  controller: 'AuthenticationController', action: 'show'

  match method: :post, path: '/auth/login',
  controller: 'AuthenticationController', action: 'login'

  match method: :get, path: '/auth/logout',
  controller: 'AuthenticationController', action: 'logout'

  match method: :get, path: '/projects',
  controller: 'ProjectController', action: 'index'

  match method: :get, path: '/projects/new',
  controller: 'ProjectController', action: 'new'

  match method: :post, path: '/projects',
  controller: 'ProjectController', action: 'create'

  match method: :get, path: '/projects/:id',
  controller: 'ProjectController', action: 'show'

  # Router.instance.routes.each do |k,v|
  #   puts k
  #   v.each do |k2,v2|
  #     puts "#{k2} => #{v2}"
  #   end
  # end
end
