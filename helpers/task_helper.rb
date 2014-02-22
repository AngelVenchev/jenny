# Helper module for task controller and model
module TaskHelper
  STATUS_VALUES =
  {
    0 => 'Defined',
    1 => 'In Progress',
    2 => 'Finished',
    3 => 'For Testing',
    4 => 'Rejected'
  }

  def initialize_task(params)
    Task.new title: params[:title],
             description: params[:description],
             status: params[:status],
             blocked: !!params[:blocked],
             blocked_reason: params[:blocked_reason],
             estimate: params[:estimate].to_f,
             actual: params[:actual].to_f,
             to_do: params[:to_do].to_f
  end

  def successful_create(project, story, task, params)
    executor = User.find(params[:executor_id])
    tester = User.find(params[:tester_id])

    executor.tasks_as_executor << task
    tester.tasks_as_tester << task

    story.tasks << task
    flash[:notice] = "Succesfully created task #{task.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}"
  end

  def unsuccessful_create(project, story, task)
    flash[:error] = "Unable to create task #{task.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}/tasks/new"
  end

  def updated_task(params)
    task = Task.find(params[:task_id])
    task.title = params[:title]
    task.description = params[:description]
    task.status = params[:status]
    task.blocked = !!params[:blocked]
    task.blocked_reason = params[:blocked_reason]
    task.estimate = params[:estimate]
    task.actual = params[:actual]
    task.to_do = params[:to_do]
    task
  end

  def refresh_executor_and_tester(task, params)
    task.executor.tasks_as_executor.delete task
    task.tester.tasks_as_tester.delete task

    executor = User.find(params[:executor_id])
    tester = User.find(params[:tester_id])

    task = Task.find(task.id) # refetch

    executor.tasks_as_executor << task
    tester.tasks_as_tester << task
  end

  def successful_edit(project, story, task, params)
    refresh_executor_and_tester(task, params)
    flash[:notice] = "Succesfully updated task #{task.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}"
  end

  def unsuccessful_edit(project, story, task)
    flash[:error] = "Unable to update task #{task.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}/tasks/#{task.id}"
  end

  def new_locals
    current_project = Project.find(params[:project_id])
    current_story = UserStory.find(params[:story_id])

    {
      user: current_user,
      project: current_project,
      story: current_story,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
  end

  def edit_locals
    project, story, task = fetch_project_story_task(params)

    {
      user: current_user,
      project: project,
      story: story,
      task: task,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
  end

  def show_locals(params)
    project, story, task = fetch_project_story_task(params)

    {
      user: current_user,
      project: project,
      story: story,
      task: task,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
  end

  def fetch_project_story_task(params)
    project = Project.find(params[:project_id])
    story = UserStory.find(params[:story_id])
    task = Task.find(params[:task_id])
    [project, story, task]
  end
end
