class AddRequiredDraftToHeaders < ActiveRecord::Migration[5.0]
  def change
    add_column :headers, :required_draft, :boolean
  end
end
