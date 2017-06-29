class TreeItem < ApplicationRecord
  acts_as_ordered_tree

  belongs_to :project
  belongs_to :itemable,
             polymorphic: true,
             inverse_of: :tree_item
end
