module ProjectHelper
  def current_iterations(params)
    all_iterations = Iteration.all.
      order("start_date ASC").
      where("project_id = #{params[:project_id]}")
      #find_by(project_id: params[:project_id])
    if all_iterations.empty?
      []
    else
      iterations_to_be_shown(all_iterations)
    end
  end

  def iterations_to_be_shown(all)
    current = all.select(&:is_current?).first
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
end
