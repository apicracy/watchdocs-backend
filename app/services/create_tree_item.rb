class CreateTreeItem
  attr_reader :itemable, :group

  def initialize(itemable, group: nil)
    @itemable = itemable
    @group = group || itemable.group&.tree_item
  end

  def call
    return unless itemable.persisted?
    return itemable.tree_item if itemable.tree_item
    return insert_into_group if group
    insert_into_project_root
  end

  private

  def insert_into_project_root
    insert_into project_root
  end

  def insert_into_group
    insert_into group
  end

  def insert_into(tree_item)
    tree_item.children.create(itemable: itemable)
  end

  def project_root
    itemable.project.tree_root
  end
end
