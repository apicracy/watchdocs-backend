require 'rails_helper'

RSpec.describe 'DELETE /endpoints/:id', type: :request do
  let(:endpoint) { Fabricate :full_endpoint }
  let(:endpoint_id) { endpoint.id }
  let(:url) { "/api/v1/endpoints/#{endpoint_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the endpoint' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when endpoint does not exist' do
    let(:endpoint_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the endpoint' do
    let(:user) { endpoint.project.user }

    before do
      login_as user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('endpoint')
    end

    it 'removes all connected url params' do
      expect(UrlParam.count).to eq 0
    end

    it 'removes request' do
      expect(Request.count).to eq 0
    end

    it 'removes all connected responses' do
      expect(Response.count).to eq 0
    end
  end
end
