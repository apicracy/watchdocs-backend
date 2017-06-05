class JsonSchemaNormalizer
  attr_reader :schema

  def initialize(schema)
    @schema = schema.with_indifferent_access
  end

  def normalize
    normalize_node(schema)
  end

  private

  def normalize_node(node)
    return {} unless node

    case node[:type]
    when 'object'
      normalize_object(node)
    when 'array'
      normalize_array(node)
    else
      node
    end
  end


  def normalize_object(object_node)
    properties = object_node[:properties]

    properties.each do |property, value|
      properties[property] = normalize_node(value)
    end

    object_node[:required] = object_node[:required].sort if object_node[:required]
    object_node
  end

  def normalize_array(array_node)
    array_node[:items] = normalize_node(array_node[:items])
    array_node
  end
end
