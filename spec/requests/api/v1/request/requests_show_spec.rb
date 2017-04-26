require 'rails_helper'

RSpec.describe 'GET /endpoints/:endpoint_id/request', type: :request do
  let(:url) { "/api/v1/endpoints/#{endpoint.id}/request" }
  let(:endpoint) { Fabricate :endpoint, project: project }
  let(:project) { Fabricate :project }

  context 'guest user' do
    before { get url }

    it_behaves_like 'unauthorized'
  end

  context 'non owner user' do
    before do
      Fabricate :request, endpoint: endpoint
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'non existing request' do
    before do
      endpoint.request.destroy
      login_as project.user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'authenticated user' do
    let(:user) { project.user }

    before do
      Fabricate :request, endpoint: endpoint
      login_as user, scope: :user
      get url
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns required fields' do
      expect(json).to match_schema('request')
    end
  end
end
