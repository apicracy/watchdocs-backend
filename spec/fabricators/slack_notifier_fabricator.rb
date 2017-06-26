Fabricator(:slack_notifier, from: Notifications::SlackNotifier) do
  access_token 'this is token'
  webhook_url 'http://webhook.test.url'
end
