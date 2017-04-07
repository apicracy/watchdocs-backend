class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :project, foreign_key: true
      t.references :group, foreign_key: true
      t.string :name
      t.string :path
      t.text :description

      t.timestamps
    end
  end
end
