class App < Sinatra::Base
  include Sinatra::Helpers

  set :views, File.expand_path('../../views', __FILE__)
  enable :sessions, :method_override

  router = Router.instance

  get "/*" do
    router.routes[normalized_request_method][request.fullpath].call(params, self)
  end

  post "/*" do
    router.routes[normalized_request_method][request.fullpath].call(params, self)
  end

  private

  def normalized_request_method
    request.request_method.downcase.to_sym
  end
end
