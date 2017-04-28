class TreeItemSerializer < ActiveModel::Serializer
  def type
    object.class.name.freeze
  end

  def generate_tree(grupped: true, parent_serializer:)
    tree_item_collections(grupped).map do |collection|
      serialize_tree_items(collection, parent_serializer)
    end.flatten
  end

  private

  def serialize_tree_items(items, parent_serializer)
    items.map do |o|
      "#{parent_serializer}::#{o.class}Item".constantize.new(o)
    end
  end

  def tree_item_collections(grupped)
    return [object.endpoints, object.groups, object.documents] if grupped
    [
      object.documents.ungroupped,
      object.endpoints.ungroupped,
      object.groups.ungroupped
    ]
  end
end
