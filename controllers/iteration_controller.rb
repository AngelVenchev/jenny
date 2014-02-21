require 'date'

class IterationController < ApplicationController
  def new(params)
    redirect_if_not_logged_in
    locals =
    {
      user: current_user,
      project_id: params[:project_id],
      home: "/projects/#{params[:project_id]}"
    }
    haml :"iteration/new", locals: locals
  end

  def create(params)
    redirect_if_not_logged_in
    iteration = Iteration.new(
      title: params[:title],
      theme: params[:theme],
      start_date: Date.parse(params[:start_date]),
      end_date: Date.parse(params[:end_date]))


    Iteration.all.each do |i|
      overlap =
        iteration.start_date <= i.end_date &&
        i.start_date <= iteration.end_date
      if overlap
        flash[:notice] = <<END
Unable to create iteration #{params[:title]}.
It overlaps with iteraiton #{i.title}
END
        redirect back
      end
    end

    project = Project.find(params[:project_id])
    user = current_user
    if project and iteration.save
      project.iterations << iteration
      flash[:notice] = "Successfully created iteration #{params[:title]}"
      redirect "/projects/#{project.id}"
    else
      flash[:error] = "Unable to create iteration #{params[:title]}"
      redirect "/projects/#{params[:project_id]}/iterations/new"
    end
  end
end
