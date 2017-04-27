require 'rails_helper'

RSpec.describe 'PUT /responses/:id', type: :request do
  let(:response) { Fabricate :response }
  let(:response_id) { response.id }
  let(:url) { "/api/v1/responses/#{response_id}" }
  let(:user) { endpoint.project.user }
  let(:params) do
    {
      endpoint_id: 123,
      body: new_schema,
      http_status_code: 301
    }
  end
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

  context 'when user is not signed in' do
    before { put url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of a parent endpoint' do
    before do
      login_as Fabricate(:user), scope: :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when response does not exists' do
    let(:response_id) { -1 }

    before do
      login_as Fabricate(:user), scope: :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when params are correct and user owns response' do
    let(:endpoint_id) { response.endpoint_id }

    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns serialized url param' do
      expect(json).to eq(serialized(endpoint.reload))
    end

    it 'does not update endpoint_id' do
      expect(json['endpoint_id']).to eq endpoint_id
    end
  end

  context 'when param params are incorrect' do
    before do
      Fabricate(:response, http_status_code: 301, endpoint: endpoint)

      login_as user, scope: :user
      put url, params: params # Duplicating names
    end

    it_behaves_like 'invalid'
  end
end
