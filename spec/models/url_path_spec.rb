require 'rails_helper'

RSpec.describe UrlPath, type: :model do
  describe '#autocorrect' do
    subject { described_class.autocorrect(url) }
    let(:url) { '/v1/projects' }

    it 'does not change valid url' do
      is_expected.to eq(url)
    end

    context 'when leading slash is missing' do
      let(:url) { 'v1/projects' }

      it 'prepends with slash' do
        is_expected.to eq('/v1/projects')
      end
    end

    context 'when ending slash is present' do
      let(:url) { '/v1/projects/' }

      it 'removes ending with slash' do
        is_expected.to eq('/v1/projects')
      end
    end
  end
end
