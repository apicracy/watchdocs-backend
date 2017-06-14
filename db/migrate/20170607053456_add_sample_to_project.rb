class AddSampleToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :sample, :boolean
  end
end
