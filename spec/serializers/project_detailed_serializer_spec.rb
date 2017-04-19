require 'rails_helper'

# TODO: Refactor to user json schema
RSpec.describe ProjectDetailedSerializer, type: :serializer do
  subject(:serializer) { described_class.new(project) }
  let(:project) { Fabricate :project }

  describe '#tree' do
    subject(:json_tree) { JSON.parse(serializer.to_json)['tree'] }

    it 'returns not grouped endpoints and docs' do
      endpoint1 = Fabricate :endpoint, url: '/contributions', project: project
      endpoint2 = Fabricate :endpoint, url: '/pledges', project: project
      document = Fabricate :document, project: project

      expected_json = [
        {
          'id' => endpoint1.id,
          'type' => 'Endpoint',
          'url' => endpoint1.url,
          'method' => endpoint1.http_method
        },
        {
          'id' => endpoint2.id,
          'type' => 'Endpoint',
          'url' => endpoint2.url,
          'method' => endpoint2.http_method
        },
        {
          'id' => document.id,
          'type' => 'Document',
          'name' => document.name,
          'text' => group.text
        }
      ]

      expect(json_tree).to eq(expected_json)
    end

    it 'returns grouped endpoints and docs' do
      group = Fabricate :group, project: project
      endpoint1 = Fabricate :endpoint, url: '/contributions', group: group
      endpoint2 = Fabricate :endpoint, url: '/contributions/:id', group: group
      document = Fabricate :document, project: project, group: group

      expected_json = [{
        'id' => group.id,
        'type' => 'Group',
        'name' => group.name,
        'description' => group.description,
        'items' => [
          {
            'id' => endpoint1.id,
            'type' => 'Endpoint',
            'url' => endpoint1.url,
            'method' => endpoint1.http_method
          },
          {
            'id' => endpoint2.id,
            'type' => 'Endpoint',
            'url' => endpoint2.url,
            'method' => endpoint2.http_method
          },
          {
            'id' => document.id,
            'type' => 'Document',
            'name' => document.name,
            'text' => group.text
          }
        ]
      }]

      expect(json_tree).to eq(expected_json)
    end
  end
end
