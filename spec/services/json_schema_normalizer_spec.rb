require 'rails_helper'

RSpec.describe JsonSchemaNormalizer do
  let(:schema) do
    {
      'type' => 'object',
      'schema' => 'http://json-schema.org/draft-04/schema#',
      'required' => ['name', 'base_url', 'app_secret'],
      'properties' => {
        'name' => {
          'type' => 'string'
        },
        'base_url' => {
          'type' => 'string'
        },
        'endpoint' => {
          'properties' => {
            'id' => {
              'type' => 'number'
            },
            'name' => {
              'type' => 'stripng'
            },
            'stats' => {
              'properties' => {
                'stat1' => {
                  'type' => 'number'
                }
              },
              'type' => 'object'
            }
          },
          'required' => ['name', 'id'],
          'type' => 'object'
        },
        'app_secret' => {
          'type' => 'string'
        }
      }
    }
  end

  describe '.normalize' do
    subject(:normalized_hash) { described_class.normalize(schema) }

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
  end
end
