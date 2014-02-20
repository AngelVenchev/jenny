class App < Sinatra::Base
  register Sinatra::Helpers
  register Sinatra::Flash
  include RequestHelper

  set :views, File.expand_path('../../views', __FILE__)
  enable :sessions, :method_override

  router = Router.instance

  request_path = "/?:0?/?:1?/?:2?"

  get request_path do
    transfer_request(router)
  end

  post request_path do
    transfer_request(router)
  end

  private

  def normalized_request_method
    request.request_method.downcase.to_sym
  end

  def transfer_request(router)
    path = request.env["REQUEST_PATH"]
    path = request.env["PATH_INFO"] unless path
    action = router.routes[normalized_request_method][path]
    return action.call(params, self) unless action.nil?

    call_parametrized_query(path, router)
  end
end
