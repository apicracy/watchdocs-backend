require 'rails_helper'

RSpec.describe 'DELETE /url_params/:id', type: :request do
  let(:user) { endpoint.project.user }
  let(:endpoint) { Fabricate :endpoint }
  let(:url_param) { Fabricate :url_param, endpoint: endpoint }
  let(:url) { "/api/v1/url_params/#{url_param.id}" }

  context 'when user is not signed in' do
    before { delete url }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner' do
    before do
      login_as Fabricate(:user), scope: :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when user owns url param' do
    before do
      login_as user, scope: :user
      delete url
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns serialized url param' do
      expect(json).to match_schema('url_param')
    end
  end
end
