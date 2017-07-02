require 'rails_helper'

RSpec.describe BuildProjectTree do
  subject(:tree_builder) { described_class.new(root_item.descendants) }
  let(:project) { Fabricate(:project) }
  let(:root_item) { root_group.tree_item }

  let!(:root_group) { Fabricate(:group, project: project) }
  let!(:group1) { Fabricate(:group, project: project, group: root_group) }
  let!(:group2) { Fabricate(:group, project: project, group: root_group) }
  let!(:endpoint1) { Fabricate(:endpoint, project: project, group: group1) }
  let!(:endpoint2) { Fabricate(:endpoint, project: project, group: group2) }

  it 'creates hash-based tree structure from collection of descendants' do
    expect(tree_builder.call).to eq Hash[
      group1.tree_item => {
        endpoint1.tree_item => {}
      },
      group2.tree_item => {
        endpoint2.tree_item => {}
      }
    ]
  end
end
