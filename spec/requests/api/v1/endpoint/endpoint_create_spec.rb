require 'rails_helper'

RSpec.describe 'POST /endpoints', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:url) { '/api/v1/endpoints' }
  let(:params) do
    {
      project_id: project_id,
      url: '/api/v1/users/legal_identities',
      http_method: 'POST'
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project' do
    before do
      login_as Fabricate :user
      post url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when project does not exist' do
    let(:project_id) { -1 }

    before do
      login_as Fabricate :user
      post url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the project' do
    context 'and params are valid' do
      before do
        login_as project.user, scope: :user
        post url, params: params
      end

      it 'returns 200' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(Endpoint.last))
      end
    end

    context 'and url & method params are not unique' do
      before do
        Fabricate(
          :endpoint,
          url: '/api/v1/users/legal_identities',
          http_method: 'POST',
          project: project
        )
        login_as project.user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end

    context 'params are invalid' do
      before do
        params[:url] = nil
        login_as project.user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
