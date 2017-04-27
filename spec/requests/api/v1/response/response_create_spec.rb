require 'rails_helper'

RSpec.describe 'POST /responses', type: :request do
  let(:endpoint) { Fabricate :endpoint }
  let(:endpoint_id) { endpoint.id }
  let(:url) { '/api/v1/responses' }
  let(:params) do
    {
      endpoint_id: endpoint_id,
      http_status_code: 500
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

  context 'when endpoint does not exist' do
    let(:endpoint_id) { -1 }

    before do
      login_as Fabricate :user
      post url, params: params
    end

    # TODO: Change to not_found in the future
    it_behaves_like 'forbidden'
  end

  context 'when params are correct and user owns endpoint' do
    before do
      login_as endpoint.project.user, scope: :user
      post url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
      expect(json).to eq(serialized(Response.last))
    end

    it 'sets initial status to up_to_date' do
      expect(json['status']).to eq 'up_to_date'
    end
  end

  context 'when param params are incorrect' do
    before do
      login_as endpoint.project.user, scope: :user
      post url, params: { endpoint_id: endpoint.id } # Missing :status_code
    end

    it_behaves_like 'invalid'
  end
end
