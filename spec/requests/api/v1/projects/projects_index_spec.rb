require 'rails_helper'

RSpec.describe 'GET /projects', type: :request do
  let(:endpoint_path) { '/api/v1/projects' }

  context 'guest user' do
    before { get endpoint_path }

    it_behaves_like 'unauthorized request'
  end

  context 'authenticated user' do
    let(:user) { Fabricate :user }
    let!(:owned_project) { Fabricate :project, user: user }
    let!(:non_owned_project) { Fabricate :project }

    before do
      login_as user, scope: :user
      get endpoint_path
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns owned projects' do
      expect(json_items_ids).to include(owned_project.id)
    end

    it 'does not return non owned projects' do
      expect(json_items_ids).not_to include(non_owned_project.id)
    end

    it 'returns required fields' do
      expect(json.first).to eq serialized(owned_project)
    end
  end
end
