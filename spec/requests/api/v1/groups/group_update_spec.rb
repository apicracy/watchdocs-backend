require 'rails_helper'

RSpec.describe 'PUT /groups/:id', type: :request do
  let(:group) { Fabricate :group }
  let(:group_id) { group.id }
  let(:url) { "/api/v1/groups/#{group_id}" }
  let(:params) do
    {
      project_id: 12,
      name: Faker::Lorem.word,
      description: Faker::Lorem.paragraph
    }
  end

  context 'when user is unauthenticated' do
    before { put url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the group' do
    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when group does not exist' do
    let(:group_id) { -1 }

    before do
      login_as Fabricate :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the group' do
    let(:user) { group.project.user }

    context 'and params are valid' do
      let(:project_id) { group.project_id }

      before do
        login_as user, scope: :user
        put url, params: params
      end

      it 'returns 200 and serialized updated group' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(group.reload))
      end

      it 'does not update project' do
        expect(json['project_id']).to eq project_id
      end
    end

    context 'params are invalid' do
      before do
        params[:name] = nil
        login_as user, scope: :user
        put url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
