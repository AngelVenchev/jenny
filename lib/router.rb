require 'singleton'

class Router
  include Singleton

  attr_accessor :routes

  def self.init(&block)
    Router.instance.instance_eval &block
  end

  def initialize
    @routes = {}
  end

  def match(path: required, controller: required, action: required, method: :get)
    @routes[method] ||= {}
    @routes[method][path] = lambda do |params, context|
      Kernel.const_get(controller).new(context).send(action, params)
    end
  end
end
