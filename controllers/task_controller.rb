class TaskController < ApplicationController
  include TaskHelper

  def new(params)
    redirect_if_not_logged_in

    current_project = Project.find(params[:project_id])
    current_story = UserStory.find(params[:user_story_id])

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
      description: params[:description],
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

  def show(params)
    redirect_if_not_logged_in

    current_project = Project.find(params[:project_id])
    current_story = UserStory.find(params[:user_story_id])
    current_task = Task.find(params[:task_id])

    locals =
    {
      user: current_user,
      project: current_project,
      story: current_story,
      task: current_task,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :'task/show', locals: locals
  end

  def edit(params)
    redirect_if_not_logged_in

    current_task = Task.find(params[:task_id])

    current_project = Project.find(params[:project_id])
    current_story = UserStory.find(params[:user_story_id])
    current_task = Task.find(params[:task_id])

    locals =
    {
      user: current_user,
      project: current_project,
      story: current_story,
      task: current_task,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }

    haml :'task/edit', locals: locals
  end

  def update(params)
    redirect_if_not_logged_in

    task = Task.find(params[:task_id])
    task.title = params[:title]
    task.description = params[:description]
    task.status = params[:status]
    task.blocked = !!params[:blocked]
    task.blocked_reason = params[:blocked_reason]
    task.estimate = params[:estimate]
    task.actual = params[:actual]
    task.to_do = params[:to_do]

    project = Project.find(params[:project_id])
    story = UserStory.find(params[:user_story_id])

    if task.save
      task.executor.tasks_as_executor.delete task
      task.tester.tasks_as_tester.delete task

      executor = User.find(params[:executor_id])
      tester = User.find(params[:tester_id])

      task = Task.find(task.id) #refetch

      executor.tasks_as_executor << task
      tester.tasks_as_tester << task

      executor.save
      tester.save
      task.save

      flash[:notice] = "Succesfully updated task #{task.title}"
      redirect "projects/#{project.id}/user_stories/#{story.id}"
    else
      flash[:error] = "Unable to update task #{task.title}"
      redirect "projects/#{project.id}/user_stories/#{story.id}/tasks/#{task.id}"
    end
  end
end