class JsonSchemaNormalizer
  def self.normalize(schema)
    return schema unless schema['type'] == 'object'
    normalize_object(schema)
  end

  def self.normalize_object(object_node)
    object_node['properties'].each do |property, value|
      next unless value['type'] == 'object'
      object_node[property] = normalize_object(value)
    end

    object_node['required'] = object_node['required'].sort if object_node['required']
    object_node
  end
end
