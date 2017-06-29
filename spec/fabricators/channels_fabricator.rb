Fabricator(:slack_channel, from: Notifications::Channel) do
  user_id { Fabricate(:user).id }
  provider 'slack'
  active true
  notificable { Fabricate(:slack_notifier) }
end
