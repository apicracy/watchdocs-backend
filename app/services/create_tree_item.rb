class CreateTreeItem
  attr_reader :itemable

  def initialize(itemable)
    @itemable = itemable
  end

  def call
    return unless itemable.persisted?
    return itemable.tree_item if itemable.tree_item
    itemable.project
            .tree_root
            .children
            .create(itemable: itemable)
  end
end
