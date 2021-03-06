require 'rails_helper'

RSpec.describe UpdateEndpointSchemas do
  RSpec::Matchers.define_negated_matcher :not_change, :change

  subject(:processor) { described_class.new(schemas) }
  let(:schemas) { external_schema_fixture(:full) }

  context 'when project doesnt exists' do
    it 'raises exception' do
      expect { processor.call }
        .to raise_error(ProjectNotFound)
        .and not_change { Endpoint.count }
    end
  end

  context 'when project exists' do
    before do
      allow_any_instance_of(ActiveCampaignTracking).to(
        receive(:create_event).and_return(true)
      )
      Fabricate(:project, app_id: 'TEST')
    end

    context 'and top level group does not exist' do
      let(:top_level_group) do
        Fabricate(
          :group,
          name: 'Projects',
          project: Project.last
        )
      end

      let(:group) do
        Fabricate(
          :group,
          name: 'Users',
          project: Project.last,
          group: top_level_group
        )
      end

      before do
        top_level_group
        group
        processor.call
      end

      it 'adds to top level group' do
        endpoint_tree_item = Endpoint.last.tree_item
        expect(endpoint_tree_item.ancestors.count).to eq 2 # tree root and group
        expect(endpoint_tree_item.parent_id).not_to eq(group.tree_item.id)
      end
    end

    context 'and top level group exist' do
      let(:top_level_group) do
        Fabricate(
          :group,
          name: 'Users',
          project: Project.last
        )
      end

      before do
        top_level_group
        processor.call
      end

      it 'uses top level group' do
        endpoint_tree_item = Endpoint.last.tree_item
        expect(endpoint_tree_item.ancestors.count).to eq 2 # tree root and group
        expect(endpoint_tree_item.parent_id).to eq(top_level_group.tree_item.id)
      end
    end

    context 'and schema contains request data' do
      before do
        processor.call
      end

      it 'creates new endpoint' do
        expect(Endpoint.last.url).to eq(schemas[:endpoint][:url])
      end

      it 'creates request' do
        endpoint = Endpoint.last
        expect(endpoint.request).to be_present
        expect(endpoint.request.body).to eq schemas[:request][:body]
      end

      it 'creates all url params' do
        endpoint = Endpoint.last
        expect(endpoint.url_params.count).to eq(4)
        expect(endpoint.url_params.last.name).to eq('data[attributes][output_currency]')
        expect(endpoint.url_params.all?(&:required)).to be_truthy
      end
    end

    context 'and schema contains response data' do
      let(:schemas) { external_schema_fixture(:response_only) }

      before do
        processor.call
      end

      it 'creates new endpoint' do
        expect(Endpoint.last.url).to eq(schemas[:endpoint][:url])
      end

      it 'creates new response' do
        endpoint = Endpoint.last
        expect(endpoint.responses.count).to eq(1)
        expect(endpoint.responses.last.http_status_code).to eq schemas[:response][:status]
        expect(endpoint.responses.last.body).to eq schemas[:response][:body]
      end

      it 'creates request' do
        endpoint = Endpoint.last
        expect(endpoint.request).to be_present
      end

      it 'adds to group' do
        endpoint_tree_item = Endpoint.last.tree_item
        expect(endpoint_tree_item.ancestors.count).to eq 2 # tree root and group
      end
    end

    context 'and endpoint already exists with differens response schema' do
      before do
        Fabricate :group, name: 'My custom group', project: Project.last
        Fabricate :endpoint, project: Project.last,
                             url: schemas[:endpoint][:url],
                             http_method: schemas[:endpoint][:method],
                             group: Group.last
        Fabricate :response, endpoint: Endpoint.last,
                             http_status_code: schemas[:response][:status],
                             body: schema_fixture('array_of_numbers')
        processor.call
      end

      it 'sets status to outdated' do
        expect(Endpoint.last.reload).to be_outdated
      end

      it 'does not create new endpoint and response' do
        expect(Group.count).to eq(1)
        expect(Endpoint.count).to eq(1)
        expect(Response.count).to eq(1)
      end

      it 'does not change endpoint group' do
        expect(Endpoint.last.group.name).to eq 'My custom group'
      end
    end
  end
end
