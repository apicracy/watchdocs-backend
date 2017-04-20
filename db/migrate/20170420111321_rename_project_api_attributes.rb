class RenameProjectApiAttributes < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :api_key, :app_id
    rename_column :projects, :api_secret, :app_secret
  end
end
