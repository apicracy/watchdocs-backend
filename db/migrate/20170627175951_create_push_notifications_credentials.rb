class CreatePushNotificationsCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :push_notifications_credentials do |t|
      t.references :player, index: true
      t.timestamps
    end
  end
end
