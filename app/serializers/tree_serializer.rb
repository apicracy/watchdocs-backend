class TreeSerializer < ActiveModel::Serializer
  def generate_tree
    descendants = object.tree_root.descendants.includes(:itemable)
    BuildProjectTree.new(descendants).call
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

  def serialize_tree(tree)
    tree.to_a.map do |pair|
      parent, children = *pair
      item = parent.itemable
      {
        id: item.id,
        tree_item_id: parent.id,
        type: item.class.to_s
      }.merge(serialize_item(item, children))
    end
  end

  private

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
    {
      url: endpoint.url,
      status: endpoint.status,
      method: endpoint.http_method
    }
  end
end
