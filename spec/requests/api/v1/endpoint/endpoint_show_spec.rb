require 'rails_helper'

RSpec.describe 'GET /endpoint', type: :request do
  let(:endpoint) { Fabricate :endpoint }
  let(:url) { "/api/v1/endpoints/#{endpoint.id}" }

  context 'when user is unauthenticated' do
    before { get url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the endpoint' do
    before do
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when endpoint does not exist' do
    before do
      login_as Fabricate :user
      get '/api/v1/endpoints/xyz'
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the endpoint' do
    let(:user) { endpoint.project.user }

    before do
      login_as user, scope: :user
      get url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(json).to eq(serialized(endpoint))
    end
  end
end
