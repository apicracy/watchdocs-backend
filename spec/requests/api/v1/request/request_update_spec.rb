require 'rails_helper'

RSpec.describe 'PUT /url_params', type: :request do
  let(:user) { Fabricate :user }
  let(:project) { Fabricate :project, user: user }
  let(:endpoint) { Fabricate :endpoint, project: project }
  let(:request) { Fabricate :request, endpoint: endpoint }
  let(:url) { "/api/v1/endpoints/#{endpoint.id}/request" }
  let(:params) do
    {
      'body': {}
    }
  end

  context 'when user is not signed in' do
    before { put url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of a parent endpoint' do
    before do
      login_as Fabricate(:user), scope: :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when params are correct and user owns endpoint' do
    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'sets up_to_date status by default' do
      expect(UrlParam.last.status).to eq('up_to_date')
    end

    it 'returns serialized url param' do
      expect(json).to match_schema('url_param')
    end
  end
end
