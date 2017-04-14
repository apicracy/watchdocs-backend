class RemoveHeaders < ActiveRecord::Migration[5.0]
  def change
    drop_table :request_headers
    drop_table :response_headers
    drop_table :headers
  end
end
