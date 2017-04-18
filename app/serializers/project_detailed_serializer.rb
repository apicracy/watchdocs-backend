class ProjectDetailedSerializer < ActiveModel::Serializer
  attributes :id, :tree

  def tree
    object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
      object.groups.map { |group| GroupItem.new(group) }
  end

  # Class for generating an entry for group on a tree json
  class GroupItem < ActiveModel::Serializer
    attributes :id, :type, :items, :name, :description

    def type
      object.class.name.freeze
    end

    def items
      object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
        object.groups.map { |group| GroupItem.new(group) }
    end
  end

  # Class for generating an entry for endpoint on a tree json
  class EndpointItem < ActiveModel::Serializer
    attributes :id, :type, :url
    attribute :http_method, key: :method

    def type
      object.class.name.freeze
    end
  end
end
