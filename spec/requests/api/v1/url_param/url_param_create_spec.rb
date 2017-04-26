require 'rails_helper'

RSpec.describe 'POST /url_params', type: :request do
  let(:user) { Fabricate :user }
  let(:project) { Fabricate :project, user: user }
  let(:endpoint) { Fabricate :endpoint, project: project }
  let(:url) { '/api/v1/url_params' }
  let(:params) do
    {
      'endpoint_id': endpoint.id,
      'description': Faker::Lorem.paragraph,
      'is_part_of_url': false,
      'data_type': 'String',
      'name': 'search',
      'example': 'test'
    }
  end

  context 'when user is not signed in' do
    before { post url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of a parent endpoint' do
    before do
      login_as Fabricate(:user), scope: :user
      post url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when params are correct and user owns endpoint' do
    before do
      login_as user, scope: :user
      post url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'saves new url param' do
      expect(UrlParam.count).to eq(1)
    end

    it 'sets up_to_date status by default' do
      expect(UrlParam.last.status).to eq('up_to_date')
    end

    it 'returns serialized url param' do
      expect(json).to match_schema('url_param')
    end
  end

  context 'when param params are incorrect' do
    before do
      login_as user, scope: :user
      post url, params: { endpoint_id: endpoint.id } # Missing :key
    end

    it_behaves_like 'invalid'
  end
end
