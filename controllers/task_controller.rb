class TaskController < ApplicationController
  include TaskHelper

  def new(params)
    redirect_if_not_logged_in

    current_project = Project.find(params[:project_id])
    current_story = UserStory.find(params[:user_story_id])
    p "project, user, story"
    p current_project
    p current_user
    p current_story
    locals =
    {
      user: current_user,
      project: current_project,
      story: current_story,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :'task/new', locals: locals
  end

  def create(params)
    redirect_if_not_logged_in

    task = Task.new(
      title: params[:title],
      description: params[:title],
      status: params[:status],
      blocked: !!params[:blocked],
      blocked_reason: params[:blocked_reason],
      estimate: params[:estimate].to_f,
      actual: params[:actual].to_f,
      to_do: params[:to_do].to_f,
    )

    if task.save
      user = User.find(params[:executor_id])
      user.tasks_as_executor << task
      user = User.find(params[:tester_id])
      user.tasks_as_tester << task
      story = UserStory.find(params[:user_story_id])
      project = Project.find(params[:project_id])
      story.tasks << task
      flash[:notice] = "Succesfully created task #{task.title}"
      redirect "projects/#{project.id}/user_stories/#{story.id}"
    else
      flash[:error] = "Unable to create task #{task.title}"
      redirect "projects/#{project.id}/user_stories/#{story.id}/tasks/new"
    end
  end
end