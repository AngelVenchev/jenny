# Project Controller
class ProjectController < ApplicationController
  include ProjectHelper

  def new(params)
    redirect_if_not_logged_in

    haml :"project/new", locals: new_locals
  end

  def create(params)
    redirect_if_not_logged_in
    project = initialize_project(params)
    if project.save
      successful_create(project, params)
    else
      unsuccessful_create(params)
    end
  end

  def index(params)
    redirect_if_not_logged_in

    haml :'project/index', locals: index_locals
  end

  def edit(params)
    redirect_if_not_logged_in
    haml :'project/edit', locals: common_locals(params[:project_id])
  end

  def show(params)
    redirect_if_not_logged_in

    session[:offset] = 0 if params[:current] || !session[:offset]
    session[:offset] += params[:step].to_i if session[:offset].abs < Iteration.count

    haml :'project/show', locals: show_locals(params)
  end
end
