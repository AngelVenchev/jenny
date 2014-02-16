Router.init do
  match method: :get, path: '/auth/register',
  controller: 'AuthenticationController', action: 'register_new'

  match method: :post,path: '/auth/register',
  controller: 'AuthenticationController', action: 'register'

  match method: :get, path: '/auth/login',
  controller: 'AuthenticationController', action: 'show_login'

  match method: :post,path: '/auth/login',
  controller: 'AuthenticationController', action: 'login'

  match method: :get, path: '/',
  controller: 'HomeController', action: 'index'

  match method: :get, path: '/auth/logout',
  controller: 'AuthenticationController', action: 'logout'

end
