require 'rails_helper'

RSpec.describe ProjectDocumentationSerializer, type: :serializer do
  subject(:serialized) { serialized_json(serializer) }
  let(:project) { Fabricate(:project) }
  let(:serializer) { serializer_for(project) }

  context 'when project is empty' do
    it { expect(serialized).to match_schema('documentation') }
  end

  context 'when project have empty groups only' do
    before { Fabricate.times(3, :group, project: project) }

    it { expect(serialized).to match_schema('documentation') }
  end

  context 'when project have a complex structure' do
    before do
      group = Fabricate(:group, project: project)
      Fabricate(:group, project: project)
      Fabricate(:group, project: project, group: group)
      Fabricate(:full_endpoint, project: project)
      Fabricate(:full_endpoint, project: project, group: group)
    end

    it { expect(serialized).to match_schema('documentation') }
  end
end
