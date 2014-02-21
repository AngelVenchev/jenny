class TaskController < ApplicationController
  include TaskHelper

  def new(params)
    redirect_if_not_logged_in

    current_project = Project.find(params[:project_id])

    locals =
    {
      user: current_user,
      users: current_project.users,
      project: current_project,
      story: UserStory.find(params[:user_story_id]),
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :'task/new', locals: locals
  end
end