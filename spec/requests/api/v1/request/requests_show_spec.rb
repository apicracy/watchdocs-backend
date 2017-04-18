require 'rails_helper'

RSpec.describe 'GET /projects', type: :request do
  let(:tested_path) { "/api/v1/endpoints/#{endpoint.id}/request" }
  let(:endpoint) { Fabricate :endpoint, project: project }
  let(:project) { Fabricate :project }

  context 'guest user' do
    before { get tested_path }

    it_behaves_like 'unauthorized'
  end

  context 'non owner user' do
    before do
      Fabricate :request, endpoint: endpoint
      login_as Fabricate :user
      get tested_path
    end

    it_behaves_like 'not found'
  end

  context 'non existing request' do
    before do
      login_as project.user
      get tested_path
      puts response.body
    end

    it_behaves_like 'not found'
  end

  context 'authenticated user' do
    let(:user) { project.user }
    let!(:request) { Fabricate :request, endpoint: endpoint }

    before do
      login_as user, scope: :user
      get tested_path
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns required fields' do
      puts response.body
      expect(json).to match_schema('request')
    end
  end
end
