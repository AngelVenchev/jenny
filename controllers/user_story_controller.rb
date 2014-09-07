# User Story Controller
class UserStoryController < ApplicationController
  include UserStoryHelper

  def new(params)
    redirect_if_not_logged_in

    haml :"user_story/new", locals: new_locals(params)
  end

  def create(params)
    redirect_if_not_logged_in
    story = initialize_user_story(params)

    if story.save
      successful_create(story, params)
    else
      unsuccessful_create(story, params)
    end
  end

  def edit(params)
    redirect_if_not_logged_in

    haml :"user_story/edit", locals: show_locals(params)
  end

  def update(params)
    redirect_if_not_logged_in

    project = Project.find(params[:project_id])

    story = updated_story(params)

    if story.save
      successful_edit(project, story, params)
    else
      unsuccessful_edit(project, story)
    end
  end

  def show(params)
    redirect_if_not_logged_in

    haml :'user_story/show' , locals: show_locals(params)
  end
end
