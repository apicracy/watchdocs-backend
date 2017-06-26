class MoveTreeItem
  attr_reader :item, :to, :after, :before

  def initialize(item_to_move, options = {})
    @item = find_tree_item(item_to_move)
    @to = find_tree_item(options[:to])
    @after = find_tree_item(options[:after])
    @before = find_tree_item(options[:before])
  end

  def call
    return item unless item.itemable # protect from project root movement
    move_to(to) if to
    move_after(after) if after
    move_before(before) if before
    item
  end

  private

  def find_tree_item(item)
    return unless item
    if item.is_a?(Integer) || item.is_a?(String)
      TreeItem.find(item.to_i)
    elsif item.is_a?(TreeItem)
      item
    elsif item.is_a?(Groupable)
      item.tree_item
    end
  end

  def move_to(new_parent)
    item.move_to_child_of(new_parent)
  end

  def move_after(new_predecessor)
    item.move_to_bottom_of(new_predecessor)
  end

  def move_before(new_following)
    item.move_to_bottom_of(new_following)
  end
end
