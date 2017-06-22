class MoveTreeItem
  attr_reader :item, :to, :after, :before

  def initialize(item, to: nil, after: nil, before: nil)
    @item = find_tree_item(item)
    @to = find_tree_item(to) if to
    @after = find_tree_item(after) if after
    @before = find_tree_item(before) if before
  end

  def call
    move_to(to) if to
    move_after(after) if after
    move_before(before) if before
    item
  end

  private

  def find_tree_item(item)
    if item.is_a?(Integer)
      TreeItem.find(item)
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
