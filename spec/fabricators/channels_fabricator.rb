Fabricator(:slack_channel, from: Notifications::Channel) do
  user_id { Fabricate(:user).id }
  provider 'slack'
  active true
  notificable { Fabricate(:slack_notifier) }
end

Fabricator(:push_notification_channel, from: Notifications::Channel) do
  user_id { Fabricate(:user).id }
  provider 'push_notification'
  active true
  notificable { Fabricate(:push_notifications_credential) }
end
