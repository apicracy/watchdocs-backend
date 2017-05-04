require 'rails_helper'

# TODO: Refactor to user json schema
RSpec.describe ProjectTreeSerializer, type: :serializer do
  subject(:serializer) { described_class.new(project) }
  let(:project) { Fabricate :project }

  describe '#tree' do
    subject(:json_tree) { JSON.parse(serializer.to_json)['tree'] }

    it 'returns not grouped endpoints and docs' do
      endpoint1 = Fabricate :endpoint, url: '/contributions', project: project, order_number: 2
      endpoint2 = Fabricate :endpoint, url: '/pledges', project: project, order_number: 3
      document = Fabricate :document, project: project, order_number: 1

      expected_json = [
        {
          'id' => document.id,
          'type' => 'Document',
          'name' => document.name,
          'text' => document.text,
          'order_number' => 1
        },
        {
          'id' => endpoint1.id,
          'type' => 'Endpoint',
          'url' => endpoint1.url,
          'order_number' => 2,
          'method' => endpoint1.http_method
        },
        {
          'id' => endpoint2.id,
          'type' => 'Endpoint',
          'url' => endpoint2.url,
          'order_number' => 3,
          'method' => endpoint2.http_method
        }
      ]

      expect(json_tree).to eq(expected_json)
    end

    it 'returns grouped endpoints and docs' do
      group = Fabricate :group, project: project, order_number: 1
      endpoint1 = Fabricate :endpoint, url: '/contributions', group: group, order_number: 1
      endpoint2 = Fabricate :endpoint, url: '/contributions/:id', group: group, order_number: 2
      document = Fabricate :document, project: project, group: group, order_number: 3

      expected_json = [{
        'id' => group.id,
        'type' => 'Group',
        'items' => [
          {
            'id' => endpoint1.id,
            'type' => 'Endpoint',
            'url' => endpoint1.url,
            'order_number' => 1,
            'method' => endpoint1.http_method
          },
          {
            'id' => endpoint2.id,
            'type' => 'Endpoint',
            'url' => endpoint2.url,
            'order_number' => 2,
            'method' => endpoint2.http_method
          },
          {
            'id' => document.id,
            'type' => 'Document',
            'name' => document.name,
            'text' => document.text,
            'order_number' => 3
          }
        ],
        'name' => group.name,
        'description' => group.description,
        'order_number' => 1
      }]

      expect(json_tree).to eq(expected_json)
    end
  end
end
