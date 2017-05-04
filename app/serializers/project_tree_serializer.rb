class ProjectTreeSerializer < TreeItemSerializer
  attributes :id, :tree

  def tree
    generate_tree(groupped: false, parent_serializer: self.class)
  end

  # Class for generating an entry for group on a tree json
  class GroupItem < TreeItemSerializer
    attributes :id, :type, :items, :name, :description, :order_number

    def items
      generate_tree(parent_serializer: ProjectTreeSerializer)
    end
  end

  # Class for generating an entry for endpoint on a tree json
  class EndpointItem < TreeItemSerializer
    attributes :id, :type, :url, :order_number
    attribute :http_method, key: :method
  end

  class DocumentItem < TreeItemSerializer
    attributes :id, :type, :name, :text, :order_number
  end
end
