require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  subject(:endpoint) { Fabricate.build(:endpoint) }

  describe '#valid?' do
    it { is_expected.to validate_uniqueness_of(:url).scoped_to([:http_method, :project_id]) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:status) }
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
end
