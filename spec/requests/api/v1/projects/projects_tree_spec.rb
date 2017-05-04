require 'rails_helper'

RSpec.describe 'PUT /projects/:id/tree', type: :request do
  let(:project) { Fabricate :project }
  let(:project_id) { project.id }
  let(:serializer) { ProjectTreeSerializer.new(project) }
  let(:url) { "/api/v1/projects/#{project_id}/tree" }

  context 'owner user' do
    let(:user) { project.user }
    let(:json_tree) { JSON.parse(serializer.to_json)['tree'] }
    let!(:document) { Fabricate :document, project: project, order_number: 1 }
    let!(:endpoint1) { Fabricate :endpoint, url: '/contributions', project: project, order_number: 2 }
    let!(:endpoint2) { Fabricate :endpoint, url: '/pledges', project: project, order_number: 3 }
    let!(:group) { Fabricate :group, project: project, order_number: 4 }
    let!(:endpoint3) { Fabricate :endpoint, url: '/sales', project: project, order_number: 1, group: group }
    let!(:endpoint4) { Fabricate :endpoint, url: '/payments', project: project, order_number: 2, group: group }

    before do
      login_as user, scope: :user
    end

    it 'returns grouped endpoints and docs' do
      put url, params: { type: 'Group', id: group.id, group_id: nil, order_number: 1, project_id: project_id }
      expect(response.status).to eq 200
    end
  end
end
