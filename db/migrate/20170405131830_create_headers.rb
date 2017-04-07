class CreateHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :headers do |t|
      t.string :key
      t.boolean :required
      t.text :description
      t.string :example_value

      t.timestamps
    end
  end
end
