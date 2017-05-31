require 'rails_helper'

RSpec.describe GroupForUrl do
  subject(:group_for_url) { described_class.new(url: url, project: project) }

  let(:project) { Fabricate(:project) }

  context 'when group does not exist' do
    context 'and url with api and version is passed' do
      let(:url) { '/api/v2/users/test' }

      before do
        url
        group_for_url.call
      end
      it 'creates group with correct name' do
        expect(Group.last.name).to eq('Users')
      end
    end

    context 'and url with only version is passed' do
      let(:url) { '/v1/users/test' }

      before do
        url
        group_for_url.call
      end

      it 'creates group with correct name' do
        expect(Group.last.name).to eq('Users')
      end
    end

    context 'when url with only api is passed' do
      let(:url) { '/api/users/test' }

      before do
        url
        group_for_url.call
      end

      it 'creates group with correct name' do
        expect(Group.last.name).to eq('Users')
      end
    end

    context 'and url without api and version is passed' do
      let(:url) { '/users/test' }

      before do
        url
        group_for_url.call
      end

      it 'creates group with correct name' do
        expect(Group.last.name).to eq('Users')
      end
    end
  end

  context 'when group does exist' do
    let(:url) { '/api/v1/users/test' }

    before do
      url
      group_for_url.call
    end

    it 'does not create new group' do
      expect(Group.all.count).to eq 1
    end
  end
end
