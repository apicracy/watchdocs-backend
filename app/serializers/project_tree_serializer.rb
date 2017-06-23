class ProjectTreeSerializer < TreeSerializer
  attributes :id, :tree

  def tree
    serialize_tree(generate_tree)
  end
end
