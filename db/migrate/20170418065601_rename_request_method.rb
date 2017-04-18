class RenameRequestMethod < ActiveRecord::Migration[5.0]
  def change
    rename_column :endpoints, :request_method, :http_method
  end
end
