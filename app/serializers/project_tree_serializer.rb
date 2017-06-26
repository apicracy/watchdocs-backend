class ProjectTreeSerializer < AbstractTreeSerializer
  attributes :id, :tree

  def tree
    serialize_tree(generate_tree)
  end
end
