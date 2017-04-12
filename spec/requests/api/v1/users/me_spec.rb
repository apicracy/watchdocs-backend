require 'rails_helper'

RSpec.describe 'POST /users/me', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/api/v1/users/me' }

  context 'when user is authenticated' do
    before do
      login_as user, scope: :user
      get url
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns serialized current user data' do
      expect(json).to eq(serialized(user))
    end
  end

  context 'when uses is unauthenticated' do
    before { get url }
    it_behaves_like 'unauthorized request'
  end
end
