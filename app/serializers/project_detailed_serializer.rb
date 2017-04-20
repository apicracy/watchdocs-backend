class ProjectDetailedSerializer < TreeItemSerializer
  attributes :id, :tree

  def tree
    generate_tree(grupped: false, parent_serializer: self.class)
  end

  # Class for generating an entry for group on a tree json
  class GroupItem < TreeItemSerializer
    attributes :id, :type, :items, :name, :description

    def items
      generate_tree(parent_serializer: ProjectDetailedSerializer)
    end
  end

  # Class for generating an entry for endpoint on a tree json
  class EndpointItem < TreeItemSerializer
    attributes :id, :type, :url
    attribute :http_method, key: :method
  end

  class DocumentItem < TreeItemSerializer
    attributes :id, :type, :name, :text
  end
end
