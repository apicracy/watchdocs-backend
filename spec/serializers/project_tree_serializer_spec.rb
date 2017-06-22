require 'rails_helper'

# TODO: Refactor to user json schema
RSpec.describe ProjectTreeSerializer, type: :serializer do
  subject(:serializer) { described_class.new(project) }
  let(:project) { Fabricate :project }

  describe '#tree' do
    subject(:json_tree) { JSON.parse(serializer.to_json)['tree'] }

    it 'returns not grouped endpoints and docs' do
      document = Fabricate :document, project: project
      endpoint1 = Fabricate :endpoint, url: '/contributions', project: project
      endpoint2 = Fabricate :endpoint, url: '/pledges', project: project

      expected_json = [
        {
          'id' => document.id,
          'tree_item_id' => document.tree_item.id,
          'type' => 'Document',
          'name' => document.name,
          'text' => document.text
        },
        {
          'id' => endpoint1.id,
          'tree_item_id' => endpoint1.tree_item.id,
          'type' => 'Endpoint',
          'url' => endpoint1.url,
          'status' => endpoint1.status.to_s,
          'method' => endpoint1.http_method
        },
        {
          'id' => endpoint2.id,
          'tree_item_id' => endpoint2.tree_item.id,
          'type' => 'Endpoint',
          'url' => endpoint2.url,
          'status' => endpoint2.status.to_s,
          'method' => endpoint2.http_method
        }
      ]

      expect(json_tree).to eq(expected_json)
    end

    it 'returns grouped endpoints and docs' do
      group = Fabricate :group, project: project
      endpoint1 = Fabricate :endpoint, url: '/contributions', project: project, group: group
      endpoint2 = Fabricate :endpoint, url: '/contributions/:id', project: project, group: group
      document = Fabricate :document, project: project, group: group

      expected_json = [{
        'id' => group.id,
        'tree_item_id' => group.tree_item.id,
        'type' => 'Group',
        'name' => group.name,
        'description' => group.description,
        'items' => [
          {
            'id' => endpoint1.id,
            'tree_item_id' => endpoint1.tree_item.id,
            'type' => 'Endpoint',
            'url' => endpoint1.url,
            'status' => endpoint1.status.to_s,
            'method' => endpoint1.http_method
          },
          {
            'id' => endpoint2.id,
            'tree_item_id' => endpoint2.tree_item.id,
            'type' => 'Endpoint',
            'url' => endpoint2.url,
            'status' => endpoint2.status.to_s,
            'method' => endpoint2.http_method
          },
          {
            'id' => document.id,
            'tree_item_id' => document.tree_item.id,
            'type' => 'Document',
            'name' => document.name,
            'text' => document.text
          }
        ]
      }]

      expect(json_tree).to eq(expected_json)
    end
  end
end
