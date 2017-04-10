class ParseUrlParamsSchema
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def call
    params = {}
    schema['properties'].each do |param, schema|
      if schema['type'] == 'object'
        children = dig_into_url_param_hash(schema)
        children.each do |child|
          key, required = build_url_param(param, child)
          params[key] = required
        end
      else
        params[param] = schema['required'].include?(param)
      end
    end
    params
  end

  private

  def dig_into_url_param_hash(param_hash)
    params = []
    param_hash['properties'].each do |param, schema|
      if schema['type'] == 'object'
        children = dig_into_url_param_hash(schema)
        children.each { |c| params << [param, c] }
      else
        params << [param, param_hash['required'].include?(param)]
      end
    end
    params
  end

  def build_url_param(root, children)
    param = root
    children.flatten!
    required = children.pop # last element says if param is required
    children.each { |c| param += "[#{c}]" }
    [param, required]
  end
end
