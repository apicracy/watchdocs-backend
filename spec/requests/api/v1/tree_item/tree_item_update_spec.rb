require 'rails_helper'

RSpec.describe 'PUT /tree_items', type: :request do
  let(:url) { "/api/v1/tree_items/#{tree_item_id}" }
  let(:tree_item_id) { document2.tree_item.id }
  let(:project) { Fabricate(:project) }
  let(:user) { project.user }
  let(:params) { { to: group1.tree_item.id } }

  let!(:group1) { Fabricate :group, project: project }
  let!(:endpoint1) { Fabricate :endpoint, project: project, group: group1 }
  let!(:document1) { Fabricate :document, project: project, group: group1 }
  let!(:group2) { Fabricate :group, project: project }
  let!(:endpoint2) { Fabricate :endpoint, project: project, group: group2 }
  let!(:document2) { Fabricate :document, project: project, group: group2 }

  context 'when user is not signed in' do
    before { put url, params: params }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not owner of the project' do
    before do
      login_as Fabricate(:user), scope: :user
      put url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when moving to new group' do
    let(:params) { { to: group1.tree_item.id } }

    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns valid project tree' do
      expect(json).to match_schema('project_tree')
    end
  end

  context 'when moving after other tree item' do
    let(:params) { { after: endpoint1.tree_item.id } }

    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns valid project tree' do
      expect(json).to match_schema('project_tree')
    end
  end

  context 'when moving before other tree item' do
    let(:params) { { before: group1.tree_item.id } }

    before do
      login_as user, scope: :user
      put url, params: params
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns valid project tree' do
      expect(json).to match_schema('project_tree')
    end
  end

  context 'when destination not found' do
    before do
      login_as user, scope: :user
      put url, params: { to: -1 }
    end

    it_behaves_like 'not found'
  end

  context 'when source not found' do
    let(:tree_item_id) { -1 }

    before do
      login_as user, scope: :user
      put url, params: params
    end

    it_behaves_like 'not found'
  end
end
