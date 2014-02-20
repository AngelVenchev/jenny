module RequestHelper
  private

  def call_parametrized_query(path, router)
    paths = router.routes[normalized_request_method].keys
    parametrized_paths = paths.select { |p| p.include? ':'}
    real_path = parametrized_paths.select { |p| match?(path,p) }.first

    raise ArgumentError, "No such route #{path}" unless real_path

    prepare_params(real_path, params)
    router.routes[normalized_request_method][real_path].call(params, self)
  end

  # adds parametrized params from path, to params map
  def prepare_params(path, params)
    parameters = extract_params(path)
    parameters.each_with_index do |param, i|
      params[parse_sym(param)] = params[i.to_s.to_sym] if param.include? ':'
    end
  end

  # from ":id" to :id
  def parse_sym(param)
    param.split(':')[1].to_sym
  end

  def extract_params(path)
    path.gsub('/', ' ').split
  end

  def match?(path, p)
    to_match = extract_params(path)
    to_be_matched = extract_params(p)
    false unless to_match.size == to_be_matched.size
    match = true
    to_be_matched.size.times do |i|
      match = check_parameter(to_match[i], to_be_matched[i])
    end
    match
  end

  def check_parameter(to_match,to_be_matched)
    return true if to_be_matched[0].include? ':'
    to_be_matched == to_match
  end
end