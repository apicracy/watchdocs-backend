class CreateRequestHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :request_headers do |t|
      t.references :request, foreign_key: true
      t.references :header, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
