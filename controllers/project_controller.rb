class ProjectController < ApplicationController
  def new(params)
    user = User.find_by id: session[:user_id]
    locals = {user: user.username}
    haml :"project/new", locals: locals
  end

  def create(params)
    project = Project.new(name: params[:name])
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
    redirect '/' unless session[:user_id]
    user = User.find(session[:user_id])
    locals = {user: user}
    haml :'project/index', locals: locals
  end
end
