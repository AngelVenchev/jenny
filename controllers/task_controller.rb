# Task Controller
class TaskController < ApplicationController
  include TaskHelper

  def new(params)
    redirect_if_not_logged_in

    haml :'task/new', locals: new_locals
  end

  def create(params)
    redirect_if_not_logged_in

    task = initialize_task(params)

    story = UserStory.find(params[:story_id])
    project = Project.find(params[:project_id])

    if task.save
      successful_create(project, story, task, params)
    else
      unsuccessful_create(project, story, task)
    end
  end

  def show(params)
    redirect_if_not_logged_in

    haml :'task/show', locals: show_locals(params)
  end

  def edit(params)
    redirect_if_not_logged_in

    haml :'task/edit', locals: edit_locals
  end

  def update(params)
    redirect_if_not_logged_in

    task = updated_task(params)

    project = Project.find(params[:project_id])
    story = UserStory.find(params[:story_id])

    if task.save
      successful_edit(project, story, task, params)
    else
      unsuccessful_edit(project, story, task)
    end
  end
end
