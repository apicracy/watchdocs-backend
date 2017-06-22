class ProjectDocumentationSerializer < ActiveModel::Serializer
  attributes :id, :documentation

  def documentation
    descendants = object.tree_root.descendants.includes(:itemable)
    tree = BuildProjectTree.new(descendants).call
    serialize_tree(tree)
  end

  private

  def serialize_tree(tree)
    tree.to_a.map do |pair|
      parent, children = *pair
      item = parent.itemable
      {
        id: item.id,
        type: item.class.to_s
      }.merge(serialize_item(item, children))
    end
  end

  def serialize_item(item, children)
    if item.is_a?(Group)
      serialize_group(item, children)
    elsif item.is_a?(Document)
      serialize_document(item)
    elsif item.is_a?(Endpoint)
      serialize_endpoint(item)
    end
  end

  def serialize_group(group, children)
    {
      name: group.name,
      description: group.description,
      items: serialize_tree(children)
    }
  end

  def serialize_document(document)
    {
      name: document.name,
      text: document.text
    }
  end

  def serialize_endpoint(endpoint)
    EndpointItem.new(endpoint).as_json
  end

  class EndpointItem < ActiveModel::Serializer
    attributes :id,
               :url,
               :status,
               :description

    attribute :http_method, key: :method

    has_one :request
    has_many :responses
    has_many :url_params

    def responses
      object.responses.order(:http_status_code)
    end
  end
end
