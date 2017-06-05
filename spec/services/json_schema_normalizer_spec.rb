require 'rails_helper'

RSpec.describe JsonSchemaNormalizer do
  let(:schema) do
    schema_fixture('unnormalized_json_schema')
  end

  describe '.normalize' do
    subject(:normalized_hash) { described_class.new(schema).normalize }

    it 'returns a hash' do
      expect(normalized_hash).to be_a(Hash)
    end

    it 'orders alphabeticaly top level required' do
      expect(normalized_hash['required']).to eq(['app_secret', 'base_url', 'name'])
    end

    it 'orders nested required' do
      expect(normalized_hash['properties']['endpoint']['required']).to eq(['id', 'name'])
    end

    it 'does not add required for an object that does not have any' do
      expect(normalized_hash['properties']['endpoint']['properties']['stats']['required']).to be_nil
    end

    it 'sets empty object as items when null provided' do
      expect(normalized_hash['properties']['endpoint']['properties']['list']['items']).to eq({})
    end
  end
end
