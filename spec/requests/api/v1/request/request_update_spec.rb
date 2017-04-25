require 'rails_helper'

RSpec.describe 'PUT /endpoints/:endpoint_id/request', type: :request do
  let(:user) { Fabricate :user }
  let(:project) { Fabricate :project, user: user }
  let(:endpoint) { Fabricate :endpoint, project: project }
  let(:url) { "/api/v1/endpoints/#{endpoint.id}/request" }
  let(:params) { { body: JSON.generate(new_schema) } }
  let(:new_schema) do
    {
      schema: 'http://json-schema.org/draft-04/schema#',
      type: 'object',
      properties: {
        name: {
          type: 'string'
        }
      },
      required: ['name']
    }
  end

  before do
    Fabricate :request, endpoint: endpoint, body_draft: new_schema
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

    it 'updates body' do
      request_body = Request.last.reload.body
      expect(request_body.deep_symbolize_keys).to eq(new_schema)
    end

    it 'clears body draft' do
      request = Request.last.reload
      expect(request.body_draft).to be_nil
    end

    it 'returns serialized url param' do
      expect(json).to match_schema('request')
    end
  end
end
