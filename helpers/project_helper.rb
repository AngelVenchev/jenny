# Helper module for the project controller and model
module ProjectHelper
  def current_iterations(params)
    all_iterations = Iteration.all
      .order('start_date ASC')
      .where("project_id = #{params[:project_id]}")
    if all_iterations.empty?
      []
    else
      iterations_to_be_shown(all_iterations)
    end
  end

  def iterations_to_be_shown(all)
    current = all.select(&:current?).first
    current = all.last unless current

    current_index = all.index(current) + session[:offset]
    current_index = 1 if current_index <= 0
    current_index = all.size if current_index > all.size

    all[(current_index - 1)..(current_index + 1)]
  end

  def common_locals(project_id)
    {
      project: Project.find(project_id),
      user: User.find(session[:user_id]),
      home: "/projects/#{project_id}"
    }
  end

  def initialize_project(params)
    Project.new(name: params[:name], description: params[:description])
  end

  def successful_create(project, params)
    current_user.projects << project
    flash[:notice] = "Successfully created project #{params[:name]}"
    redirect '/projects'
  end

  def unsuccessful_create(params)
    flash[:error] = "Unable to create project with name #{params[:name]}"
    redirect '/projects/new'
  end

  def new_locals
    other_users = User.all.sample(21).select { |u| u != current_user }.take 20
    {
      user: current_user,
      other_users: other_users,
      home: '/projects'
    }
  end

  def index_locals
    {
      user: current_user,
      home: '/projects'
    }
  end

  def show_locals(params)
    locals = common_locals(params[:project_id])
    locals[:iterations] = current_iterations(params)
    backlog = UserStory.where iteration_id: nil,
                              project_id: params[:project_id]
    locals[:backlog] = backlog

    locals
  end
end
