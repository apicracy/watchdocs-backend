class CreateResponseHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :response_headers do |t|
      t.references :response, foreign_key: true
      t.references :header, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
