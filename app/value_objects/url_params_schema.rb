# TODO: Switch comments into specs

# This class defines value object for JSON schema
# with url query string params for endpoint.
#
# Example schema:
# {
#   "schema": "http://json-schema.org/draft-04/schema#",
#   "type": "object",
#   "properties": {
#     "data": {
#       "type": "object",
#       "required": ["type", "attributes"],
#       "properties": {
#         "type": {
#           "type": "string"
#         },
#         "attributes": {
#           "type": "object",
#           "required": ["amount"],
#           "properties": {
#             "amount": {
#               "type": "string"
#             },
#           }
#         }
#       }
#     }
#   },
#   "required": ["data"]
# }

class UrlParamsSchema
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  # Extract all url params from schema and retruns
  # them in hash where key is a url formated param
  # and value says if it's required.
  #
  # Example:
  # {
  #   "data[type]" => true,
  #   "data[attributes][amount]" => true
  # }
  # TODO: Add type recogition support

  def params
    params = {}
    schema['properties'].each do |param, schema|
      if schema['type'] == 'object'
        params.merge(build_params_recursively(param, schema))
      else
        params[param] = schema['required'].present? &&
                        schema['required'].include?(param)
      end
    end
    params
  end

  private

  def build_params_recursively(parent, children)
    params = {}
    params_data = params_from_hash(children)
    params_data.each do |param_data|
      key, required = build_url_param(parent, param_data)
      params[key] = required
    end
    params
  end

  def params_from_hash(param_hash)
    params = []
    param_hash['properties'].each do |param, schema|
      if schema['type'] == 'object'
        children = params_from_hash(schema)
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
