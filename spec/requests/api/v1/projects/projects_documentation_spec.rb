require 'rails_helper'

RSpec.describe 'GET /projects/:id/documentation', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:url) { "/api/v1/projects/#{project_id}/documentation" }

  context 'when uses is unauthenticated' do
    before { get url }

    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project' do
    before do
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when project doesnt exist' do
    let(:project_id) { '-100' }

    before do
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'when user is authenticated and authorized' do
    let(:user) { project.user }

    before do
      login_as user, scope: :user
      get url
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns required fields' do
      expect(json).to eq match_schema('documentation')
    end
  end
end
