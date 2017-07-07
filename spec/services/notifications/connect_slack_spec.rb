require 'rails_helper'

RSpec.describe Notifications::ConnectSlack do
  subject(:service) { described_class.new(user: user, code: code) }
  let(:user) { Fabricate :user }
  let(:code) { 'code' }

  context 'when code is valid' do
    before do
      stub_request(:post, "https://slack.com/api/oauth.access")
        .to_return(status: 200,
                   body: '{"ok":true, "access_token":"access-token-ff685fdd8669cf1b", "scope":"identify,incoming-webhook", "user_id":"USER12ID", "team_name":"team-name", "team_id":"TEAM1", "incoming_webhook": {"channel":"#top_secret", "channel_id":"CHANN12", "configuration_url":"https://team-name.slack.com/services/SECRET", "url":"https://hooks.slack.com/services/TEAM1/USER12ID/SECRET"}}')
    end

    it 'returns true' do
      result = service.call
      expect(result).to be_truthy
    end

    it 'makes a call to reports service' do
      service.call
      expect(a_request(:post, "https://slack.com/api/oauth.access")).to have_been_made
    end

    it 'Creates slack channel for user' do
      expect { service.call }.to(
        change { Notifications::Channel.where(user_id: user.id).slack.count }.to(1)
      )
    end
  end

  context 'when user already has connected slack account' do
    before do
      Fabricate :slack_channel, user_id: user.id
    end

    it 'returns raises error' do
      expect { service.call }.to raise_error(SlackConnectError)
    end
  end

  context 'when slack API returns error' do
    before do
      stub_request(:post, "https://slack.com/api/oauth.access")
        .to_return(status: 200,
                   body: '{"ok":false, "error":"code_already_used"}')
    end

    it 'returns raises error' do
      expect { service.call }.to raise_error(SlackConnectError)
    end
  end
end
