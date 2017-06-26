class AddPublicFlagToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :public, :boolean, default: false
  end
end
