class CreateNotificationsChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.integer :user_id
      t.string :notificable_type
      t.integer :notificable_id
      t.integer :provider
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
