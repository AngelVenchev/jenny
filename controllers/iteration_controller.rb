require 'date'

# Iteration Controller
class IterationController < ApplicationController
  include IterationHelper

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

    iteration = initialize_iteration

    overlapping = valid_overlapping(iteration)
    redirect_back if overlapping

    project = Project.find(params[:project_id])
    if project && iteration.save
      successful_create(project, iteration, params)
    else
      unsuccessful_create(params)
    end
  end
end
