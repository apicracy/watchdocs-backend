require 'rails_helper'

RSpec.describe 'POST /groups', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:url) { '/api/v1/groups' }
  let(:params) do
    {
      project_id: project_id,
      name: 'API group'
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

    it_behaves_like 'forbidden'
  end

  context 'when project does not exist' do
    let(:project_id) { -1 }

    before do
      login_as Fabricate :user
      post url, params: params
    end

    # TODO: Change to not_found in the future
    it_behaves_like 'forbidden'
  end

  context 'when user is the owner of the project' do
    context 'and params are valid' do
      before do
        login_as project.user, scope: :user
        post url, params: params
      end

      it 'returns 200 and serialized group' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(Group.last))
      end
    end

    context 'params are invalid' do
      before do
        params[:name] = nil
        login_as project.user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
