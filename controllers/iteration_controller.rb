require 'date'

class IterationController < ApplicationController
  def new(params)
    redirect_if_not_logged_in
    locals =
    {
      user: current_user,
      project_id: params[:project_id],
      home: "/projects/#{params[:project_id]}"
    }
    haml :"iteration/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in
    iteration = Iteration.new(
      title: params[:title],
      theme: params[:theme],
      start_date: Date.parse(params[:start_date]),
      end_date: Date.parse(params[:end_date]))

    p iteration
    project = Project.find(params[:project_id])
    p project
    p current_user
    user = current_user
    if project and iteration.save
      project.iterations << iteration
      flash[:notice] = "Successfully created iteration #{params[:title]}"
      redirect "/projects/#{project.id}"
    else
      flash[:error] = "Unable to create iteration #{params[:title]}"
      redirect "/projects/#{params[:project_id]}/iterations/new"
    end
  end

  # def index(params)
  #   redirect_if_not_logged_in
  #   user = User.find(session[:user_id])
  #   locals = {user: user, home: '/projects'}
  #   haml :'project/index', locals: locals
  # end

  # def edit(params)
  #   redirect_if_not_logged_in
  #   haml :'project/edit', locals: common_locals(params[:id])
  # end

  # def show(params)
  #   redirect_if_not_logged_in

  #   locals = common_locals(params[:id])

  #   all_iterations = Iteration.all.order("start_date ASC")

  #   session[:offset] = 0 if params[:current] or not session[:offset]
  #   session[:offset] += params[:step].to_i if session[:offset].abs < all_iterations.size

  #   locals[:iterations] = current_iterations(all_iterations)

  #   haml :'project/show', locals: locals
  # end
end
