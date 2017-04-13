class ProjectDetailedSerializer < ActiveModel::Serializer
  attributes :id, :tree

  def tree
    object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
      object.groups.map { |group| GroupItem.new(group) }
  end

  # We don't want GroupItem and EndpointItem to be reused
  private

  # Class for generating an entry for group on a tree json
  class GroupItem < ActiveModel::Serializer
    attributes :id, :type, :items

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
    attributes :id, :type, :method, :url

    # If not used, this will throw an error as 'method' is available within
    # ActiveModel::Serializer scope
    delegate :method, to: :object

    def type
      object.class.name.freeze
    end
  end
end
