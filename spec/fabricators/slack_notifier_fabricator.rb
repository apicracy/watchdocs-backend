Fabricator(:slack_credentials, from: Notifications::SlackCredential) do
  access_token 'this is token'
  webhook_url 'http://webhook.test.url'
end
