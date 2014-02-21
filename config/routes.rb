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

  match method: :get, path: '/projects/:project_id/edit',
  controller: 'ProjectController', action: 'edit'

  match method: :get, path: '/projects/:project_id',
  controller: 'ProjectController', action: 'show'

  match method: :get, path: 'projects/:project_id/iterations/new',
  controller: 'IterationController', action: 'new'

  match method: :post, path: 'projects/:project_id/iterations',
  controller: 'IterationController', action: 'create'
end
