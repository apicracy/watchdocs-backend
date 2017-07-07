class RenameTableSlackNotifierToSlackCredential < ActiveRecord::Migration[5.0]
  def change
    rename_table :slack_notifiers, :slack_credentials
  end
end
