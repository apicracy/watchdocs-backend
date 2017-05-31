class CleanupAfterAutoaddingHeaders < ActiveRecord::Migration[5.0]
  def change
    remove_column :headers, :required_draft, :boolean
    remove_column :headers, :status, :integer
  end
end
