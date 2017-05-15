class RenameUrlParamModel < ActiveRecord::Migration[5.0]
  def change
    rename_column :url_params, :key, :name
    rename_column :url_params, :example_value, :example
  end
end
