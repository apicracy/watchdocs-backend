module Groupable
  extend ActiveSupport::Concern

  included do
    attr_writer :group

    has_one :tree_item,
            as: :itemable,
            inverse_of: :itemable,
            dependent: :destroy

    belongs_to :project

    # TODO: remove after TreeItem deploy
    # needed for migration to new structure
    belongs_to :old_group,
               class_name: Group,
               foreign_key: :group_id,
               optional: true

    after_create :insert_to_project_tree
  end

  def group
    @group || tree_item&.parent&.itemable
  end

  private

  def insert_to_project_tree
    CreateTreeItem.new(self).call
  end
end
