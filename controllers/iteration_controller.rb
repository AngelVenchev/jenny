require 'date'

# Iteration Controller
class IterationController < ApplicationController
  include IterationHelper

  def new(params)
    redirect_if_not_logged_in
    project = Project.find(params[:project_id])

    locals =
    {
      user: current_user,
      project: project,
      home: "/projects/#{params[:project_id]}"
    }
    haml :"iteration/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in

    iteration = initialize_iteration(params)
    unsuccessful_create(params) unless iteration

    redirect_back unless valid_overlapping(iteration, params)

    project = Project.find(params[:project_id])
    if project && iteration.save
      successful_create(project, iteration, params)
    else
      unsuccessful_create(params)
    end
  end
end
