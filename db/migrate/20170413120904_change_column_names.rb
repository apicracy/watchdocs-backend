class ChangeColumnNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :url_params, :type, :data_type
    rename_column :url_params, :query_string, :is_part_of_url
    rename_column :endpoints, :method, :request_method
  end
end
