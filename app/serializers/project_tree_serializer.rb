class ProjectTreeSerializer < AbstractTreeSerializer
  attributes :id, :tree, :tree_root_id

  def tree
    serialize_tree(generate_tree)
  end

  def tree_root_id
    object.tree_root.id
  end
end
