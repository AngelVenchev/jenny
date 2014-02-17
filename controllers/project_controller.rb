class ProjectController < ApplicationController
  def new_asd(params)
    # show different view
    session[:show_name_text_box] = true
    redirect '/'
  end

  def create(params)
    project = Project.new(name:params[:name])
    user = User.find_by id:session[:user_id]
    if project.save
      user.projects << project
      flash[:notice] = "Successfully created project #{params[:name]}"
      redirect '/'
    else
      flash[:notice] = "Unable to create project with name #{params[:name]}"
      redirect '/'
    end
  end
end