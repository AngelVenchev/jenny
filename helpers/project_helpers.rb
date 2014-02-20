module ProjectHelper
  def common_locals(project_id)
    {
      project: Project.find(project_id),
      user: User.find(session[:user_id]),
      home: "/project/#{project_id}"
    }
  end

  def iterations_to_be_shown(all)
    current = all.select(&:is_current?).first
    current = all.last unless current

    current_index = all.index(current) + session[:offset]
    current_index = 1 if current_index <= 0
    current_index = all.size if current_index > all.size

    all[(current_index - 1)..(current_index + 1)]
  end

  def current_iterations(all_iterations)
    if all_iterations.empty?
      []
    else
      iterations_to_be_shown(all_iterations)
    end
  end
end
