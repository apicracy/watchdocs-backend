class CreateTreeItems < ActiveRecord::Migration[5.0]
  def change
    create_table :tree_items do |t|
      t.references :project, foreign_key: true
      t.references :item, polymorphic: true
      t.integer :parent_id
      t.integer :position

      t.timestamps
    end
  end
end
