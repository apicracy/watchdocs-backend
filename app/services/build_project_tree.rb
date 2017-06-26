class BuildProjectTree
  include Enumerable

  attr_reader :items, :cache

  def initialize(items)
    @items = items
    @cache = {}
  end

  def call
    items.each_with_object({}) do |node, result|
      cache[node.id] ||= node
      insertion_point = result

      ancestors(node).each do |a|
        insertion_point = (insertion_point[a] ||= {})
      end

      insertion_point[node] = {}
    end
  end

  private

  def ancestors(node)
    parent = cache[node.parent_id]
    parent ? ancestors(parent) + [parent] : []
  end
end
