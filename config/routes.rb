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

  match method: :get, path: '/project/new',
  controller: 'ProjectController', action:'new_asd'

  match method: :post, path: '/project',
  controller: 'ProjectController', action:'create'
end
