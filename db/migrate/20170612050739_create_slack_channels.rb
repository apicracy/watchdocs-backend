class CreateSlackChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_channels do |t|
      t.string :access_token
      t.string :webhook_url

      t.timestamps
    end
  end
end
