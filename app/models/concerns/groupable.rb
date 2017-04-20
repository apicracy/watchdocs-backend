module Groupable
  extend ActiveSupport::Concern

  included do
    belongs_to :group, optional: true
    belongs_to :project

    scope :ungroupped,
          -> { where(group_id: nil) }
  end
end
