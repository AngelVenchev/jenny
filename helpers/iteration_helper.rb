# Helper for iteration controller and model
module IterationHelper
  def initialize_iteration(params)
    Iteration.new title: params[:title],
                  theme: params[:theme],
                  start_date: Date.parse(params[:start_date]),
                  end_date: Date.parse(params[:end_date])
  end

  def valid_overlapping
    Iteration.all.each do |i|
      overlap = iteration.start_date <= i.end_date &&
                i.start_date <= iteration.end_date
      return false unless overlap
    end
    true
  end

  def redirect_back
    flash[:notice] = 'Unable to create iteration it overlaps with another iteraiton'
    redirect back
  end

  def successful_create(project, iteraion, params)
    project.iterations << iteration
    flash[:notice] = "Successfully created iteration #{params[:title]}"
    redirect "/projects/#{project.id}"
  end

  def unsuccessful_create(params)
    flash[:error] = "Unable to create iteration #{params[:title]}"
    redirect "/projects/#{params[:project_id]}/iterations/new"
  end
end
