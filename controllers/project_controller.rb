class ProjectController < ApplicationController
  include ProjectHelper

  def new(params)
    redirect_if_not_logged_in
    user = User.find_by id: current_user_id
    other_users = User.all.sample(21).select { |u| u != user}.take 20
    locals = {user: user, other_users: other_users, home: '/projects' }
    haml :"project/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in
    project = Project.new(name: params[:name], description: params[:description])
    user = User.find_by id: current_user_id
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
    locals = {user: current_user, home: '/projects'}
    haml :'project/index', locals: locals
  end

  def edit(params)
    redirect_if_not_logged_in
    haml :'project/edit', locals: common_locals(params[:project_id])
  end

  def show(params)
    redirect_if_not_logged_in

    session[:offset] = 0 if params[:current] or not session[:offset]
    session[:offset] += params[:step].to_i if session[:offset].abs < Iteration.count

    locals = common_locals(params[:project_id])
    locals[:iterations] = current_iterations

    haml :'project/show', locals: locals
  end
end
