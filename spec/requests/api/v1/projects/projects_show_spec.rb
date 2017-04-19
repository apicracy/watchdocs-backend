require 'rails_helper'

RSpec.describe 'GET /projects/:id', type: :request do
  let(:project) { Fabricate :project }
  let(:url) { "/api/v1/projects/#{project.id}" }

  context 'guest user' do
    before { get url }

    it_behaves_like 'unauthorized'
  end

  context 'non owner user' do
    before do
      login_as Fabricate :user
      get url
    end

    it_behaves_like 'not found'
  end

  context 'not existing project' do
    before do
      login_as Fabricate :user
      get '/api/v1/projects/xyz'
    end

    it_behaves_like 'not found'
  end

  context 'owner user' do
    let(:user) { project.user }
    before do
      login_as user, scope: :user
      get url
    end

    it 'returns OK status' do
      expect(response.status).to eq 200
    end

    it 'returns required fields' do
      expect(json.keys).to eq %w(id tree)
    end
  end
end
