require 'rails_helper'

RSpec.describe SyncUrlParams do
  RSpec::Matchers.define_negated_matcher :not_change, :change

  let(:endpoint) { Fabricate.build(:endpoint, url: '/:owner/:repo') }

  context 'when endpoint is new' do
    before { described_class.new(endpoint).call }

    it 'creates new url params' do
      expect(endpoint.url_params.count).to eq 2
    end

    it 'sets correct param name' do
      expect(endpoint.url_params.last.name).to eq 'repo'
    end

    it 'flags params as part of url' do
      expect(endpoint.url_params.last.is_part_of_url).to be_truthy
    end

    it 'marks as required' do
      expect(endpoint.url_params.last.required).to be_truthy
    end

    it 'sets status to up_to_date' do
      expect(endpoint.url_params.last).to be_up_to_date
    end
  end

  context 'when endpoint is being updated with new url' do
    let!(:endpoint) { Fabricate(:endpoint, url: '/:owner/:repo') }

    before do
      endpoint.url = '/:owner_id/:repo_id'
      described_class.new(endpoint).call
    end

    it 'creates new url params and keeps old' do
      expect(endpoint.url_params.count).to eq 4
    end

    it 'sets correct param name' do
      expect(endpoint.url_params.last.name).to eq 'repo_id'
    end

    it 'flags old params as stale' do
      expect(endpoint.url_params.first).to be_stale
    end

    it 'flags old params as not required' do
      expect(endpoint.url_params.first.required).to be_falsy
    end
  end
end
