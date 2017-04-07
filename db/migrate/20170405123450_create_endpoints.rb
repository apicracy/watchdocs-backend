class CreateEndpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :endpoints do |t|
      t.references :group, foreign_key: true
      t.references :project, foreign_key: true
      t.string :url
      t.string :method
      t.integer :status
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
