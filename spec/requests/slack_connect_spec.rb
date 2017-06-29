require 'rails_helper'

RSpec.describe 'POST /auth/slack/connect', type: :request do
  let(:url) { '/auth/slack/connect' }
  let(:code) { 'secret_code' }
  let(:user) { Fabricate(:user) }
  let(:params) do
    { code: code }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is signed in' do
    before { login_as user }

    context 'and user has no connected slack account' do
      before do
        stub_request(:post, "https://slack.com/api/oauth.access")
          .to_return(status: 200,
                     body: '{"ok":true, "access_token":"access-token-ff685fdd8669cf1b", "scope":"identify,incoming-webhook", "user_id":"USER12ID", "team_name":"team-name", "team_id":"TEAM1", "incoming_webhook": {"channel":"#top_secret", "channel_id":"CHANN12", "configuration_url":"https://team-name.slack.com/services/SECRET", "url":"https://hooks.slack.com/services/TEAM1/USER12ID/SECRET"}}')
        post url, params: params
      end

      it 'returns 200' do
        expect(response.status).to eq 200
      end
    end

    context 'and user already has connected slack account' do
      before do
        Fabricate :slack_channel, user_id: user.id
        post url, params: params
      end

      it 'returns 400' do
        expect(response.status).to eq 400
      end
    end

    context 'slack API returns error' do
      before do
        stub_request(:post, "https://slack.com/api/oauth.access")
          .to_return(status: 200,
                     body: '{"ok":false, "error":"code_already_used"}')
        post url, params: params
      end

      it 'returns 400' do
        expect(response.status).to eq 400
      end
    end
  end
end
