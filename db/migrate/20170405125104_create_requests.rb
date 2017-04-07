class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.references :endpoint, foreign_key: true
      t.integer :status
      t.jsonb :body
      t.jsonb :body_draft

      t.timestamps
    end
  end
end
