module Groupable
  extend ActiveSupport::Concern

  included do
    has_one :tree_item,
            as: :itemable,
            inverse_of: :itemable

    belongs_to :project
    belongs_to :group, optional: true

    scope :ungroupped,
          -> { where(group_id: nil) }
  end
end
