class CreatePolymorficHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :headers do |t|
      t.references :headerable, polymorphic: true
      t.string :key
      t.boolean :required
      t.boolean :required_draft
      t.string :description
      t.string :example_value
      t.integer :status
      t.timestamps
    end
  end
end
