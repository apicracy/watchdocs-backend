class ProjectDetailedSerializer < ActiveModel::Serializer
  attributes :id, :tree

  def tree
    object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
      object.groups.map { |group| GroupItem.new(group) }
  end

  class GroupItem < ActiveModel::Serializer
    attributes :id, :type, :items

    def type
      'Group'.freeze
    end

    def items
      object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
        object.groups.map { |group| GroupItem.new(group) }
    end
  end

  class EndpointItem < ActiveModel::Serializer
    attributes :id, :type, :method, :url

    def type
      'Endpoint'.freeze
    end

    def method
      object.method
    end
  end
end
