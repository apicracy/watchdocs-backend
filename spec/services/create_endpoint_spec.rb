require 'rails_helper'

RSpec.describe CreateEndpoint do
  let(:endpoint_creator) { described_class.new(params) }
  let(:project) { Fabricate(:project) }
  let(:params) do
    {
      project: project,
      url: '/test',
      http_method: 'GET'
    }
  end

  before do
    allow_any_instance_of(ActiveCampaignTracking).to(
      receive(:create_event).and_return(true)
    )
  end

  context 'when params are valid' do
    it 'creates new endpoint' do
      expect { endpoint_creator.call }.to change { Endpoint.count }.by(1)
    end

    it 'returns endpoint' do
      endpoint = endpoint_creator.call
      expect(endpoint).to be_a Endpoint
    end

    it 'tracks first endpoint creation' do
      expect_any_instance_of(ActiveCampaignTracking).to(
        receive(:create_event).once
      )
      endpoint_creator.call
    end
  end

  context 'when params are invalid' do
    before { params[:url] = '' }

    it 'does not create new endpoint' do
      expect { endpoint_creator.call }.not_to change { Endpoint.count }
    end

    it 'returns endpoint' do
      endpoint = endpoint_creator.call
      expect(endpoint).to be_a Endpoint
    end

    it 'does not track endpoint creation' do
      allow(ActiveCampaignTracking).to receive(:for)
      endpoint_creator.call
      expect(ActiveCampaignTracking).not_to have_received(:for)
    end
  end

  context 'when is not the first endpoint' do
    before { Fabricate(:endpoint, project: project) }

    it 'does not track endpoint creation' do
      allow(ActiveCampaignTracking).to receive(:for)
      endpoint_creator.call
      expect(ActiveCampaignTracking).not_to have_received(:for)
    end
  end
end
