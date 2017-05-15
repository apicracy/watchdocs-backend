require 'rails_helper'

RSpec.describe 'GET /responses/:id', type: :request do
  let(:url) { "/api/v1/responses/#{response_id}" }
  let(:response_object) { Fabricate :response }
  let(:response_id) { response_object.id }
  let(:project) { response_object.endpoint.project }

  context 'when uses is unauthenticated' do
    before { get url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project that response belongs to' do
    before do
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'forbidden'
  end

  context 'when response doesnt exist' do
    let(:response_id) { '-100' }

    before do
      login_as project.user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when user is authenticated and have access to response' do
    before do
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
