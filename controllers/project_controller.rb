class ProjectController < ApplicationController
  include ProjectHelper

  def new(params)
    redirect_if_not_logged_in
    user = User.find_by id: session[:user_id]
    other_users = User.all.sample(21).select { |u| u != user}.take 20
    locals = {user: user, other_users: other_users, home: '/projects' }
    haml :"project/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in
    project = Project.new(name: params[:name], description: params[:description])
    user = User.find_by id: session[:user_id]
    if user and project.save
      user.projects << project
      session[:show_name_text_box] = false
      flash[:notice] = "Successfully created project #{params[:name]}"
      redirect '/projects'
    else
      flash[:error] = "Unable to create project with name #{params[:name]}"
      redirect '/projects/new'
    end
  end

  def index(params)
    redirect_if_not_logged_in
    user = User.find(session[:user_id])
    locals = {user: user, home: '/projects'}
    haml :'project/index', locals: locals
  end

  def edit(params)
    redirect_if_not_logged_in
    haml :'project/edit', locals: common_locals(params[:id])
  end

  def show(params)
    redirect_if_not_logged_in

    locals = common_locals(params[:id])

    all_iterations = Iteration.all.order("start_date ASC")

    session[:offset] = 0 if params[:current] or not session[:offset]
    session[:offset] += params[:step].to_i if session[:offset].abs < all_iterations.size

    locals[:iterations] = current_iterations(all_iterations)

    haml :'project/show', locals: locals
  end
end
