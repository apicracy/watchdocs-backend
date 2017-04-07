class CreateUrlParams < ActiveRecord::Migration[5.0]
  def change
    create_table :url_params do |t|
      t.references :endpoint, foreign_key: true
      t.string :key
      t.integer :status
      t.boolean :required
      t.string :type
      t.text :description
      t.string :example_value
      t.boolean :query_string

      t.timestamps
    end
  end
end
