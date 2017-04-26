require 'rails_helper'

RSpec.describe 'PUT /endpoints/:id', type: :request do
  let(:endpoint) { Fabricate :endpoint }
  let(:endpoint_id) { endpoint.id }
  let(:url) { "/api/v1/endpoints/#{endpoint_id}" }
  let(:params) do
    {
      project_id: 12,
      group_id: Fabricate(:group).id,
      url: '/api/v1/users/legal_identities',
      http_method: 'POST',
      title: Faker::Lorem.word,
      summary: "<p>#{Faker::Lorem.paragraph}<p>"
    }
  end

  context 'when user is unauthenticated' do
    before { put url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the endpoint' do
    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when endpoint does not exist' do
    let(:endpoint_id) { -1 }

    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the endpoint' do
    let(:user) { endpoint.project.user }

    context 'and params are valid' do
      let(:project_id) { endpoint.project_id }

      before do
        login_as user, scope: :user
        put url, params: params
      end

      it 'returns 200 and serialized updated endpoint' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(endpoint.reload))
      end

      it 'does not update project' do
        expect(json['project_id']).to eq project_id
      end
    end

    context 'params are invalid' do
      before do
        params[:url] = nil
        login_as user, scope: :user
        put url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
