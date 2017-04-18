class RenameResponseStatusCode < ActiveRecord::Migration[5.0]
  def change
    rename_column :responses, :status_code, :http_status_code
  end
end
