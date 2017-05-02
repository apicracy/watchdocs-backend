require 'rails_helper'

RSpec.describe 'DELETE /groups/:id', type: :request do
  let(:group) { Fabricate :group }
  let(:group_id) { group.id }
  let(:url) { "/api/v1/groups/#{group_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the group' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when group does not exist' do
    let(:group_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the group' do
    before do
      login_as group.project.user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('group')
    end
  end
end
