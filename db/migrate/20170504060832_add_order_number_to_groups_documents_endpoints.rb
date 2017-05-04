class AddOrderNumberToGroupsDocumentsEndpoints < ActiveRecord::Migration[5.0]
  def up
    add_column :endpoints, :order_number, :integer
    add_column :documents, :order_number, :integer
    add_column :groups, :order_number, :integer
  end

  def down
    remove_column :endpoints, :order_number, :integer
    remove_column :documents, :order_number, :integer
    remove_column :groups, :order_number, :integer
  end
end
