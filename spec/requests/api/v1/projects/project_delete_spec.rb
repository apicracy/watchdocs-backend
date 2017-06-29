require 'rails_helper'

RSpec.describe 'DELETE /projects/:id', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:url) { "/api/v1/projects/#{project_id}" }

  context 'when user is unauthenticated' do
    before { delete url }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project' do
    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'forbidden'
  end

  context 'when project does not exist' do
    let(:project_id) { -1 }

    before do
      login_as Fabricate :user
      delete url
    end

    it_behaves_like 'not found'
  end

  context 'when user is the owner of the project' do
    let(:user) { project.user }

    before do
      login_as user, scope: :user
      delete url
    end

    it 'returns 200' do
      expect(response.status).to eq 200
      expect(response.body).to match_schema('project')
    end

    it 'removes all connected data' do
      expect(Project.count).to eq 0
      expect(UrlParam.count).to eq 0
      expect(Request.count).to eq 0
      expect(Response.count).to eq 0
      expect(Header.count).to eq 0
    end
  end
end
