require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  subject(:endpoint) { Fabricate.build(:endpoint) }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:url).scoped_to([:http_method, :project_id]) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:http_method) }
    it { is_expected.to validate_presence_of(:project) }

    it { is_expected.to allow_value('/v1/projects/:id').for(:url) }
    it { is_expected.to allow_value('/v1').for(:url) }
    it { is_expected.to allow_value('/v1/').for(:url) }
    it { is_expected.to allow_value('v1/').for(:url) }
    it { is_expected.not_to allow_value('/v1?param=1').for(:url) }
    it { is_expected.not_to allow_value('/v1/pa:ram').for(:url) }
  end

  describe '#autocorrect_url' do
    context 'when leading slash is missing' do
      before do
        endpoint.url = 'v1/projects'
        endpoint.save
      end

      it 'prepends with slash' do
        expect(endpoint.reload.url).to start_with('/')
      end
    end

    context 'when ending slash is present' do
      before do
        endpoint.url = '/v1/projects/'
        endpoint.save
      end

      it 'removes ending with slash' do
        expect(endpoint.reload.url).not_to end_with('/')
      end
    end

    context 'when url is correct' do
      let(:correct_url) { '/v1/projects' }

      before do
        endpoint.url = correct_url
        endpoint.save
      end

      it 'does not change it' do
        expect(endpoint.reload.url).to eq correct_url
      end
    end
  end

  describe '#build_request' do
    before { endpoint.save }

    it 'creates request automatically for the new endpoint' do
      expect(endpoint.request).to be_persisted
    end
  end

  describe '#set_status' do
    subject(:endpoint) { Fabricate :endpoint }
    context 'having outdated response' do
      before do
        Fabricate :outdated_response, endpoint: endpoint
        endpoint.save
      end

      it 'sets endpoint status to outdated' do
        expect(endpoint).to be_outdated
      end
    end

    context 'having outdated request' do
      before do
        Fabricate :outdated_request, endpoint: endpoint
        endpoint.save
      end

      it 'sets endpoint status to outdated' do
        expect(endpoint).to be_outdated
      end
    end

    context 'having outdated url param' do
      before do
        Fabricate :outdated_url_param, endpoint: endpoint
        endpoint.save
      end

      it 'sets endpoint status to outdated' do
        expect(endpoint).to be_outdated
      end
    end

    context 'having up to date response, request and url param' do
      before do
        Fabricate :response, endpoint: endpoint
        Fabricate :request, endpoint: endpoint
        Fabricate :url_param, endpoint: endpoint
        endpoint.save
      end

      it 'sets endpoint status to up_to_date' do
        expect(endpoint).to be_up_to_date
      end
    end
  end
end
