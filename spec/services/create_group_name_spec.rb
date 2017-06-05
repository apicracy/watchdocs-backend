require 'rails_helper'

RSpec.describe CreateGroupName do
  subject(:group_name) { described_class.new(url: url) }

  context 'when url with api and version is passed' do
    let(:url) { '/api/v2/users/test' }

    before do
      url
    end
    it 'creates group with correct name' do
      expect(group_name.parse_url).to eq('Users')
    end
  end

  context 'when url with only version is passed' do
    let(:url) { '/v1/users/test' }

    before do
      url
    end

    it 'creates group with correct name' do
      expect(group_name.parse_url).to eq('Users')
    end
  end

  context 'when url with only api is passed' do
    let(:url) { '/api/users/test' }

    before do
      url
    end

    it 'creates group with correct name' do
      expect(group_name.parse_url).to eq('Users')
    end
  end

  context 'when url without api and version is passed' do
    let(:url) { '/users/test' }

    before do
      url
    end

    it 'creates group with correct name' do
      expect(group_name.parse_url).to eq('Users')
    end
  end

  context 'when url empty is passed' do
    let(:url) { '' }

    before do
      url
    end

    it 'creates group with correct name' do
      expect(group_name.parse_url).to eq('Other')
    end
  end
end
