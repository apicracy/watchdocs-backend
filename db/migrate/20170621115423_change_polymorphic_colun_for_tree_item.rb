class ChangePolymorphicColunForTreeItem < ActiveRecord::Migration[5.0]
  def change
    rename_column :tree_items, :item_id, :itemable_id
    rename_column :tree_items, :item_type, :itemable_type
  end
end
