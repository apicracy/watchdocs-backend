require 'rails_helper'

RSpec.describe 'PUT /endpoints/:id', type: :request do
  let(:project) { Fabricate(:project) }
  let(:project_id) { project.id }
  let(:url) { "/api/v1/projects/#{project_id}" }
  let(:params) do
    {
      name: 'Watchdocs.io Ltd.',
      base_url: 'https://watchdocs.io/',
      public: true
    }
  end

  context 'when user is unauthenticated' do
    before { put url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner' do
    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when project does not exist' do
    let(:project_id) { -1 }

    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner' do
    let(:user) { project.user }

    context 'and params are valid' do
      before do
        login_as user, scope: :user
        put url, params: params
      end

      it 'returns 200 and serialized updated project' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(project.reload))
      end
    end

    context 'params are invalid' do
      let(:params) do
        { base_url: 'not_an_url' }
      end

      before do
        login_as user, scope: :user
        put url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
