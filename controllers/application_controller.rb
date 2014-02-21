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

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find session[:user_id] if logged_in?
  end

  def redirect_if_not_logged_in
    redirect '/' unless logged_in?
  end

  def current_user_id
    session[:user_id]
  end
end
