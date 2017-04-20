class ProjectDocumentationSerializer < TreeItemSerializer
  attributes :id, :documentation

  def documentation
    generate_tree(grupped: false, parent_serializer: self.class)
  end

  class GroupItem < TreeItemSerializer
    attributes :id, :type, :items, :name, :description

    def items
      generate_tree(parent_serializer: ProjectDocumentationSerializer)
    end
  end

  class EndpointItem < TreeItemSerializer
    attributes :id,
               :type,
               :url,
               :status,
               :description

    attribute :http_method, key: :method

    has_one :request
    has_many :responses
    has_many :url_params
  end

  class DocumentItem < TreeItemSerializer
    attributes :id, :type, :name, :text
  end
end