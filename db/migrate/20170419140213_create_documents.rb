class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.references :project, foreign_key: true
      t.references :group, foreign_key: true
      t.string :name
      t.string :text

      t.timestamps
    end
  end
end
