class RenameSclackChannelToSlackNotifier < ActiveRecord::Migration[5.0]
  def change
    rename_table :slack_channels, :slack_notifiers
  end
end
