require 'rails_helper'

RSpec.describe 'POST /endpoints', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:url) { '/api/v1/endpoints' }
  let(:params) do
    {
      project_id: project_id,
      url: '/api/v1/users/legal_identities',
      http_method: 'POST'
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }
    it_behaves_like 'unauthorized'
  end

  context 'when user is not the owner of the project' do
    before do
      login_as Fabricate :user
      post url, params: params
    end

    it_behaves_like 'forbidden'
  end

  context 'when project does not exist' do
    let(:project_id) { -1 }

    before do
      login_as Fabricate :user
      post url, params: params
    end

    # TODO: Change to not_found in the future
    it_behaves_like 'forbidden'
  end

  context 'when user is the owner of the project' do
    context 'and params are valid' do
      before do
        allow_any_instance_of(ActiveCampaignTracking).to(
          receive(:create_event).and_return(true)
        )
        login_as project.user, scope: :user
        post url, params: params
      end

      it 'returns 200 and serialized endpoint' do
        expect(response.status).to eq 200
        expect(json).to eq(serialized(Endpoint.last))
      end

      it 'sets initial status to up_to_date' do
        expect(json['status']).to eq 'up_to_date'
      end

      it 'returns auto-created request with id' do
        expect(json['request']['id']).to eq Request.last.id
      end

      it 'creates title of endpoint' do
        expect(json['title']).to be_present
      end

      it 'creates description of endpoint' do
        expect(json['description']).to be_present
      end
    end

    context 'and url & method params are duplicated' do
      before do
        existing_endpoint = Fabricate.build :endpoint
        existing_endpoint.attributes = params
        existing_endpoint.save

        login_as project.user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end

    context 'params are invalid' do
      before do
        params[:url] = nil
        login_as project.user, scope: :user
        post url, params: params
      end

      it_behaves_like 'invalid'
    end
  end
end
