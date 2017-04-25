require 'rails_helper'

RSpec.describe 'PUT /url_params/:id', type: :request do
  let(:user) { endpoint.project.user }
  let(:endpoint) { Fabricate :endpoint }
  let(:url_param) { Fabricate :url_param, endpoint: endpoint }
  let(:url) { "/api/v1/url_params/#{url_param.id}" }
  let(:params) do
    {
      'description': Faker::Lorem.paragraph,
      'is_part_of_url': false,
      'data_type': 'String',
      'name': 'search',
      'example': 'test'
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

  context 'when params are correct and user owns url param' do
    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns serialized url param' do
      expect(json).to match_schema('url_param')
    end
  end

  context 'when param params are incorrect' do
    before do
      Fabricate :url_param, name: 'TEST', endpoint: endpoint

      login_as user, scope: :user
      put url, params: { name: 'TEST' } # Duplicating names
    end

    it_behaves_like 'error'
  end
end
