require 'rails_helper'

RSpec.describe 'POST /projects', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/api/v1/projects' }
  let(:params) do
    {
      name: 'Watchdocs.io Ltd.',
      base_url: 'https://watchdocs.io/'
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is authenticated', :vcr do
    context 'and params are valid' do
      before do
        login_as user, scope: :user
        post url, params: params
      end

      it 'returns 200 and serialized project' do
        expect(response.status).to eq 200
        expect(json.keys).to eq %w(id name base_url updated_at app_id app_secret)
      end

      it 'generates api credentials' do
        expect(Project.last.app_id).to be_present
        expect(Project.last.app_secret).to be_present
      end
    end

    context 'and params are invalid' do
      before do
        params[:name] = nil
        login_as user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end

    context 'and reports service is unavaliable' do
      before do
        stub_request(
          :post,
          /#{CreateProjectInReportsService::REPORTS_SERVICE_PROJECTS_PATH}/
        ).to_return(status: 500)
        login_as user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
