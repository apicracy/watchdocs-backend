class TreeItemSerializer < ActiveModel::Serializer
  def type
    object.class.name.freeze
  end

  def generate_tree(groupped: true, parent_serializer:)
    tree_items(groupped).map do |item|
      serialize_tree_item(item, parent_serializer)
    end
  end

  private

  def serialize_tree_item(item, parent_serializer)
    "#{parent_serializer}::#{item.class}Item".constantize.new(item)
  end

  def tree_items(groupped)
    items = if groupped
              object.endpoints + object.groups + object.documents
            else
              object.documents.ungroupped + object.endpoints.ungroupped +
                object.groups.ungroupped
            end
    items.sort_by(&:order_number)
  end
end
