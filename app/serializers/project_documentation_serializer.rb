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

    def description
      return if object.title.blank? && object.summary.blank?
      {
        title: object.title,
        content: object.summary
      }
    end

    def responses
      object.responses.order(:http_status_code)
    end
  end

  class DocumentItem < TreeItemSerializer
    attributes :id, :type, :name, :text
  end
end
