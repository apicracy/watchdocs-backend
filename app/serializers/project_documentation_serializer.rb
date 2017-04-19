class ProjectDocumentationSerializer < ActiveModel::Serializer
  attributes :id, :documentation

  def documentation
    object.endpoints.map { |endpoint| EndpointItem.new(endpoint) } +
      object.groups.map { |group| GroupItem.new(group) }
  end

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

  class EndpointItem < ActiveModel::Serializer
    attributes :id,
               :type,
               :url,
               :status,
               :description

    attribute :http_method, key: :method

    def type
      object.class.name.freeze
    end

    has_one :request
    has_many :responses
    has_many :url_params
  end
end
