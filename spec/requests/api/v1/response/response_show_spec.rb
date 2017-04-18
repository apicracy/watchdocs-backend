require 'rails_helper'

RSpec.describe 'GET /responses/:id', type: :request do
  let(:url) { "/api/v1/responses/#{id}" }
  let(:endpoint) { Fabricate :endpoint }
  let(:project) { endpoint.project }

  context 'when uses is unauthenticated' do
    before { get url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project that response belongs to' do
    before do
      Fabricate :response, endpoint: endpoint
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when response doesnt exist' do
    before do
      login_as project.user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when user is authenticated and have access to response' do
    before do
      Fabricate :response, endpoint: endpoint
      login_as project.user, scope: :user
      get url
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns required fields' do
      expect(json).to match_schema('response')
    end
  end
end
