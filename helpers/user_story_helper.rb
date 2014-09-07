# Helper module for user story contorller and model
module UserStoryHelper
  STATUS_VALUES =
  {
    0 => 'Finished',
    1 => 'In Progress',
    2 => 'Rejected'
  }

  def initialize_user_story(params)
    UserStory.new title: params[:title],
                  description: params[:description],
                  status: params[:status].to_i
  end

  def successful_create(story, params)
    Project.find(params[:project_id]).user_stories << story
    if params[:iteration_id].to_i != -1
      Iteration.find(params[:iteration_id].to_i).user_stories << story
    end
    flash[:notice] = "Successfully created user story #{story.title}"
    redirect "/projects/#{params[:project_id]}"
  end

  def unsuccessful_create(story, params)
    flash[:error] = "Unable to create user story #{story.title}"
    redirect "/projects/#{params[:project_id]}/user_stories/new"
  end

  def new_locals(params)
    project = Project.find(params[:project_id])
    iteration = Iteration.where(project_id: params[:project_id])

    {
      user: current_user,
      project: project,
      iterations: iteration,
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
  end

  def show_locals(params)
    project = Project.find(params[:project_id])
    story = UserStory.find(params[:story_id])

    {
      user: current_user,
      project: project,
      story: story,
      statuses: STATUS_VALUES,
      task_statuses: TaskHelper.statuses,
      home: "/projects/#{params[:project_id]}"
    }
  end

  def updated_story(params)
    story = UserStory.find(params[:story_id])

    story.title = params[:title]
    story.description = params[:description]
    story.status = params[:status].to_i
    story.iteration_id = params[:iteration_id].to_i

    story
  end

  def successful_edit(project, story, params)
    flash[:notice] = "Succesfully updated user story #{story.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}"
  end

  def unsuccessful_edit(project, story)
    flash[:error] = "Unable to update user story #{story.title}"
    redirect "projects/#{project.id}/user_stories/#{story.id}/edit"
  end
end
