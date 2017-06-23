class MigrateTreeStructure < ActiveRecord::Migration[5.0]
  def change
    Rails.logger.level = :debug
    Project.all.find_each do |project|
      project.create_tree_root unless project.tree_root
      next unless project.tree_root.persisted?

      project.groups.each do |group|
        create_tree_item_for_group(group)
      end

      project.endpoints.each do |endpoint|
        CreateTreeItem.new(endpoint).call
        next unless endpoint.group
        MoveTreeItem.new(endpoint, to: endpoint.group).call
      end

      project.documents.each do |document|
        CreateTreeItem.new(document).call
        next unless document.group
        MoveTreeItem.new(document, to: document.group).call
      end
    end
  end

  private

  def create_tree_item_for_group(group)
    CreateTreeItem.new(group).call
    parent = group.group
    return unless parent
    create_tree_item_for_group(parent) unless parent.tree_item
    MoveTreeItem.new(group, to: parent).call
  end
end
