Dir['./controllers/*.rb'].each { |file| require Dir.pwd + file[1..-1] }

class Router
  attr_accessor :routes

  def self.a(&block)
    Router.new.instance_eval &block
  end

  def match(path,controller:,action:)
   @routes[path] = -> { Kernel.const_get(controller).new.send(action,params) }
  end
end