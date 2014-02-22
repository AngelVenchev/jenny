# Helper module for the router class
module RequestHelper
  private

  def evaluate_query(path, router)
    paths = router.routes[normalized_request_method].keys
    real_path = paths.select { |p| match?(path, p) }.first

    fail ArgumentError, "No such route #{path}" unless real_path

    prepare_params(real_path, params)
    router.routes[normalized_request_method][real_path].call(params, self)
  end

  def match?(path, p)
    to_match, to_be_matched = extract_params(path), extract_params(p)
    return false unless to_match.size == to_be_matched.size
    to_be_matched.size.times do |i|
      match = check_parameter(to_match[i], to_be_matched[i])
      return false unless match
    end
    true
  end

  def check_parameter(to_match, to_be_matched)
    return true if to_be_matched[0].include? ':'
    to_be_matched == to_match
  end

  # adds parametrized parts from path, to params hash
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
end
