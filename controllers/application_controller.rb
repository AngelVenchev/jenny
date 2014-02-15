class ApplicationController < Delegator
  def initialize(app)
    super
    @app = app
  end

  def __getobj__
    @app
  end

  def __setobj__(obj)
    @app = obj
  end
end
