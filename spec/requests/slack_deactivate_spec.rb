require 'rails_helper'

RSpec.describe 'POST /auth/slack/deactivate', type: :request do
  let(:url) { '/auth/slack/deactivate' }
  let(:user) { Fabricate(:user) }

  context 'when user is unauthenticated' do
    before { post url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is signed in' do
    before { login_as user }

    context 'and user has no connected slack account' do
      before do
        post url
      end

      it 'returns 403 unauthorized' do
        expect(response.status).to eq 403
      end
    end

    context 'and user already has connected slack account' do
      before do
        Fabricate :slack_channel, user_id: user.id
        post url
      end

      it 'returns 200' do
        expect(response.status).to eq 200
      end
    end
  end
end
