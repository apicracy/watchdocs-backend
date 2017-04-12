require 'rails_helper'

RSpec.describe 'GET /projects', type: :request do
  let(:endpoint_path) { '/api/v1/projects' }

  context 'guest user' do
    before { get endpoint_path }

    it 'returns unauthorized response' do
      expect(response.status).to eq 100
    end
  end

  context 'authenticated user' do
    let(:user) { Fabricate :user }
    let(:owned_project) { Fabricate :project, user: user }
    let(:non_owned_project) { Fabricate :project }

    before do
      non_owned_project
      owned_project
      login_as user, scope: :user
      get endpoint_path
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns owned projects' do
      project_ids = json.map { |project| project['id'] }
      expect(project_ids).to include(owned_project.id)
    end

    it 'does not return non owned projects' do
      project_ids = json.map { |project| project['id'] }
      expect(project_ids).not_to include(non_owned_project.id)
    end

    it 'returns required fields' do
      expect(json.first.keys).to eq %w(id name base_url updated_at)
    end
  end
end
