class UserStoryController < ApplicationController
  include UserStoryHelper

  def new(params)
    redirect_if_not_logged_in
    params.inspect
    locals =
    {
      user: current_user,
      project_id: params[:project_id],
      iterations: Iteration.all.where(project_id: params[:project_id]),
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :"user_story/new", locals: locals
  end

  def create(params)
    params.inspect
  end
end