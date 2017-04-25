require 'rails_helper'

RSpec.describe EndpointSerializer, type: :serializer do
  let(:endpoint) { Fabricate(:endpoint) }
  let(:serializer) { serializer_for(endpoint) }
  subject { serialized_json(serializer) }

  context 'when endpoint does not have associations' do
    it { is_expected.to match_schema('endpoint') }
  end

  context 'when endpoint have all associations' do
    before do
      Fabricate(:request, endpoint: endpoint)
      Fabricate(:response, endpoint: endpoint)
      Fabricate(:url_param, endpoint: endpoint)
    end

    it { is_expected.to match_schema('endpoint') }
  end
end
