class UserStoryController < ApplicationController
  include UserStoryHelper

  def new(params)
    redirect_if_not_logged_in
    locals =
    {
      user: current_user,
      project: Project.find(params[:project_id]),
      iterations: Iteration.all.where(project_id: params[:project_id]),
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :"user_story/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in
    story = UserStory.new(
      title: params[:title],
      description: params[:description],
      status: params[:status].to_i,)

    if story.save
      Project.find(params[:project_id]).user_stories << story
      if params[:iteration_id].to_i != -1
        Iteration.find(params[:iteration_id].to_i).user_stories << story
      end
      flash[:notice] = "Successfully created user story #{story.title}"
      redirect "/projects/#{params[:project_id]}"
    else
      flash[:error] = "Unable to create user story #{story.title}"
      redirect "/projects/#{params[:project_id]}/user_stories/new"
    end
  end

  def show(params)
    redirect_if_not_logged_in
    locals =
    {
      user: current_user,
      project: Project.find(params[:project_id]),
      story: UserStory.find(params[:user_story_id]),
      statuses: STATUS_VALUES,
      home: "/projects/#{params[:project_id]}"
    }
    haml :'user_story/show' , locals: locals
  end
end