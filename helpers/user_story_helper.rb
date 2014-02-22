# Helper module for user story contorller and model
module UserStoryHelper
  STATUS_VALUES =
  {
    0 => 'Defined',
    1 => 'In Progress',
    2 => 'Finished'
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
      home: "/projects/#{params[:project_id]}"
    }
  end
end
