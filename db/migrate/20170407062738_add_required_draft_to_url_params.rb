class AddRequiredDraftToUrlParams < ActiveRecord::Migration[5.0]
  def change
    add_column :url_params, :required_draft, :boolean
  end
end
